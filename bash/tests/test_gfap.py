#!/usr/bin/env python3

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]


class GfapTests:
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        root = Path(self.temp.name)
        self.remote = root / "remote.git"
        self.repo = root / "repo"
        self.env = {key: value for key, value in os.environ.items() if not key.startswith("GIT_")}
        self.env.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull, GIT_TERMINAL_PROMPT="0")

        self.git("init", "--bare", "--initial-branch=main", str(self.remote), cwd=root)
        self.git("clone", str(self.remote), str(self.repo), cwd=root)
        self.git("config", "user.name", "Test User")
        self.git("config", "user.email", "test@example.com")
        (self.repo / "base").write_text("base\n")
        self.git("add", "base")
        self.git("commit", "-m", "base")
        self.git("push", "-u", "origin", "main")

        for branch in ("gone-a", "gone-b", "gone-c", "live"):
            self.git("checkout", "-b", branch, "main")
            (self.repo / branch).write_text(f"{branch}\n")
            self.git("add", branch)
            self.git("commit", "-m", branch)
            self.git("push", "-u", "origin", branch)

        self.git("checkout", "main")
        self.git("merge", "--squash", "gone-a")
        self.git("commit", "-m", "squash gone-a")
        self.git("push", "origin", "main")
        self.git("push", "origin", "--delete", "gone-a", "gone-b", "gone-c")
        self.git("branch", "no-upstream")

    def git(self, *args, cwd=None, check=True):
        return subprocess.run(
            ["git", *args],
            cwd=cwd or self.repo,
            env=self.env,
            text=True,
            capture_output=True,
            check=check,
        )

    def gfap(self, answers):
        return subprocess.run(
            [
                *self.shell,
                "-c",
                "alias gfap='echo old'; source \"$1\"; source \"$1\"; gfap",
                self.shell[0],
                str(self.script),
            ],
            cwd=self.repo,
            env=self.env,
            input=answers,
            text=True,
            capture_output=True,
        )

    def exists(self, branch):
        return self.git("show-ref", "--verify", "--quiet", f"refs/heads/{branch}", check=False).returncode == 0

    def test_confirm_decline_eof_and_fetch_failure(self):
        self.git("remote", "add", "broken", str(self.remote.parent / "missing.git"))
        failed = self.gfap("y\ny\ny\n")
        self.assertNotEqual(failed.returncode, 0)
        self.assertTrue(self.exists("gone-a"))
        self.assertNotIn("Force-delete", failed.stderr)
        self.git("remote", "remove", "broken")

        result = self.gfap("y\nn\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("could not read confirmation", result.stderr)
        self.assertFalse(self.exists("gone-a"))
        self.assertTrue(self.exists("gone-b"))
        self.assertTrue(self.exists("gone-c"))
        self.assertTrue(self.exists("live"))
        self.assertTrue(self.exists("no-upstream"))

        result = self.gfap("n\nn\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(self.exists("gone-b"))
        self.assertTrue(self.exists("gone-c"))

        result = self.gfap("Y\ny\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.exists("gone-b"))
        self.assertFalse(self.exists("gone-c"))
        result = self.gfap("")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("Force-delete", result.stderr)

    def test_checked_out_branch_is_not_deleted(self):
        self.git("checkout", "gone-a")
        result = self.gfap("y\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue(self.exists("gone-a"))
        self.assertIn("worktree", result.stderr)


class BashGfapTest(GfapTests, unittest.TestCase):
    shell = ("bash", "--noprofile", "--norc", "-O", "expand_aliases")
    script = ROOT / "bash/.bashrc.d/30-git.sh"


class ZshGfapTest(GfapTests, unittest.TestCase):
    shell = ("zsh", "-f")
    script = ROOT / "zsh/.zshrc.d/30-git.zsh"


if __name__ == "__main__":
    unittest.main()
