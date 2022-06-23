import re
import os
import requests
from glob import glob
from itertools import groupby

DEFAULT_TEXT = """
import sequtils, strutils, strformat, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{.warning[UnusedImport]: off.}

let input = iterator: string =
    while true:
        for w in stdin.readLine().split():
            yield w
""".strip()+"\n"*2

def groupby_sorted(l, key=lambda x:x):
    return [(k, list(g)) for k, g in groupby(sorted(l, key=key), key=key)]

ROOT = os.getcwd()
def to_path(*args):
    return os.path.join(ROOT, *args)
def create_file(name_or_path):
    with open(name_or_path, 'x', encoding="utf-8") as f:
        f.write(DEFAULT_TEXT)

CONTEST_URL_PATTERN = r"(?:^https://)?atcoder.jp/contests/([^/]+)(?:/.+)?"
ALL_CONTESTS_URL = "https://kenkoooo.com/atcoder/resources/contests.json"
ALL_PROBLEMS_URL = "https://kenkoooo.com/atcoder/resources/merged-problems.json"
ALL_CONTESTS = requests.get(ALL_CONTESTS_URL).json()
ALL_CONTESTS_DICT = dict(groupby_sorted(ALL_CONTESTS, key=lambda x:x["id"]))
ALL_CONTEST_IDS = set(c['id'] for c in ALL_CONTESTS)
ALL_PROBLEMS = requests.get(ALL_PROBLEMS_URL).json()
CONTEST_PROBLEMS_DICT = dict(groupby_sorted(ALL_PROBLEMS, key=lambda x:x["contest_id"]))

# print(*CONTEST_PROBLEMS_DICT["typical90"], sep='\n')

def to_contest_id(url):
    match_obj = re.search(CONTEST_URL_PATTERN, url)
    if match_obj:
        contest_id = match_obj.group(1)
        return contest_id
    return None

def char_pattern(c):
    if '0' <= c <= '9':
        return 0
    elif 'a' <= c <= 'z' or "A" <= c <= "Z":
        return 1
    elif c in' \t\n':
        return 2
    else:
        return -1
def to_tmp_file_path(problem, working_path):
    contest_id = problem["contest_id"]
    symbol = problem['id'][-1]
    name = f"{symbol}_*.nim"
    pattern = os.path.join(working_path, contest_id, name)
    l = glob(pattern)
    if l:
        return l[0]
def to_full_file_name(problem):
    symbol = problem['id'][-1]
    t = problem["title"].lower()
    l = list(' '.join(t.split(' ')[1:]))
    l_alnum = [c for c in l if char_pattern(c) >= 0]
    words = [''.join(g) for k, g in groupby(l_alnum, key=char_pattern) if 0 <= k <= 1]
    name = '_'.join(words)
    full_file_name = f"{symbol}_{name}.nim"
    return full_file_name
def manage_file(problem, working_path):
    contest_id = problem["contest_id"]
    full_file_name = to_full_file_name(problem)
    full_file_path = os.path.join(working_path, contest_id, full_file_name)
    tmp_file_path = to_tmp_file_path(problem, working_path)
    # exist
    if os.path.isfile(full_file_path):
        pass
    # tmp exist
    elif tmp_file_path:
        os.rename(tmp_file_path, full_file_path)
    # not exist
    else:
        create_file(full_file_path)

def manage_dir(contest_id, working_dir=""):
    working_path = os.path.join(ROOT, working_dir)
    contest_path = os.path.join(working_path, contest_id)
    if not os.path.isdir(contest_path):
        os.makedirs(contest_path)
    if contest_id in ALL_CONTEST_IDS:
        # update_files
        problems = CONTEST_PROBLEMS_DICT[contest_id]
        for p in problems:
            manage_file(p, working_path=working_path)
    else:
        # generate_files
        symbols = "abcdefgh"
        for s in symbols:
            tmp_name = f"{s}_.nim"
            tmp_path = os.path.join(working_path, tmp_name)
            if os.path.isfile(tmp_path):
                continue
            create_file(tmp_path)

contest_types = ["abc", "arc", "agc"]
def get_contest_type(contest_id):
    for t in contest_types:
        if contest_id.startswith(t):
            return t
    return "else"

def io_manage_dir():
    contest_id = None
    t = input("url: ")
    contest_id = to_contest_id(t)
    if contest_id:
        pass
    else:
        raise Exception("invalid url")
    manage_dir(contest_id, get_contest_type(contest_id))

if __name__ == "__main__":
    io_manage_dir()
