import requests, json, os
from pprint import pprint

def cdHere():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
cdHere()

DotExtention = ".nim"
# NamingStyle = "snake"
NamingStyle = "camel"
BaseCodeFileName = "baseCode.nim"
ContestGroupsDirPath = "../"

def mySplit(s: str, sep: set[str]) -> list[str]:
    res = []
    idx = 0
    while idx < len(s):
        # skip spaces
        while idx < len(s) and (s[idx] in sep):
            idx += 1
        startIdx = idx
        while idx < len(s) and (s[idx] not in sep):
            idx += 1
        if startIdx < idx:
            res.append(s[startIdx:idx])
    return res
def toCamelCaseStr(strs: list[str]) -> str:
    result = ""
    for i, s in enumerate(strs):
        s = s.lower()
        if i >= 1:
            s = s.capitalize()
        result += s
    return result
def charSet(start: str, num: int) -> set[str]:
    s = ord(start)
    return {chr(s+i) for i in range(num)}
allAlnumSet = charSet('0', 10) | charSet('a', 26) | charSet('A', 26)
allAsciiSet = {chr(i) for i in range(256)}
allNotAlnumSet = allAsciiSet - allAlnumSet
# print(mySplit("a.abc , dafew -- eaあいうえ おか", allNotAlnumSet))
def formatNamingStr(s: str) -> str:
    result = ""
    words = mySplit(s, allNotAlnumSet)
    if NamingStyle == "camel":
        result = toCamelCaseStr(words)
    elif NamingStyle == "snake":
        result = words.join("_")
    return result

## url to problems
## - get json with atcoderProblemsApi
## - get problems
## - json to table
ApiProblems = "https://kenkoooo.com/atcoder/resources/problems.json"
res = requests.get(ApiProblems)
allProblems = json.loads(res.content)
# destructive
for p in allProblems:
    if p["problem_index"] == "Ex":
        p["problem_index"] = "h"
    p["problem_index"] = p["problem_index"].lower()

## - groupUp problems by contest
problemsByContest = dict()
for pDict in allProblems:
    cId = pDict["contest_id"]
    if cId not in problemsByContest:
        problemsByContest[cId] = []
    problemsByContest[cId].append(pDict)
# pprint(problemsByContest)
def tryRenameOrCreate(condFunc, filePath):
    dirPath = os.path.dirname(filePath)
    fileName = os.path.basename(filePath)
    if not os.path.isdir(dirPath):
        os.mkdir(dirPath)
    lsSet = os.listdir(dirPath)
    if fileName in lsSet:
        print(f"'{fileName}' exist.")
        return
    for f in lsSet:
        if condFunc(f):
            beforePath = os.path.join(dirPath, f)
            os.rename(beforePath, filePath)
            print(f"rename '{f}' to '{fileName}'")
            return
    with open(filePath, 'w', encoding="utf-8"):
        pass
    print(f"create '{fileName}'")

def solve(url):
    ## url to files
    ## - validate url
    if not url.startswith("https://atcoder.jp/contests/"):
        print("invalid url: not atcoderContestUrl.")
        return False
    ## - prepare contestId
    words = url[len("https://atcoder.jp/contests/"):].split("/")
    if len(words) <= 0:
        print("invalid url: it do not have contestId.")
        return False
    contestId = words[0]

    groupDirName = "else"
    if contestId.startswith("abc"):
        groupDirName = "abc"
    elif contestId.startswith("arc"):
        groupDirName = "arc"
    elif contestId.startswith("agc"):
        groupDirName = "agc"
    contestDirPath = os.path.join(
        ContestGroupsDirPath,
        groupDirName,
        formatNamingStr(contestId)
    )
    # real time contest init
    if contestId not in problemsByContest:
        if not os.path.isdir(contestDirPath):
            os.mkdir(contestDirPath)
        for pIdx in "abcdefgh":
            fileName = pIdx + DotExtention
            filePath = os.path.join(contestDirPath, fileName)
            tryRenameOrCreate(
                lambda name: (name.startswith(pIdx) and name.endswith(DotExtention)),
                filePath
            )
        print(f"init for real time contest.")
        return True
    # - get problems
    contestProblems = problemsByContest[contestId]
    ## - problems[contestId] to correctFileNames
    correctFileNames = []
    for pDict in contestProblems:
        pIdx = pDict["problem_index"]
        name = pDict["name"]
        fileName = formatNamingStr(f"{pIdx} {name}") + DotExtention
        correctFileNames.append(fileName)

    ##  prepare base code
    baseCode = None
    with open(BaseCodeFileName, 'r', encoding="utf-8") as f:
        baseCode = f.read()
    ##
    for pDict, correctFileName in zip(contestProblems, correctFileNames):
        ## exist or rename or create
        pIdx = pDict["problem_index"]
        correctFilePath = os.path.join(contestDirPath, correctFileName)
        tryRenameOrCreate(
            lambda name: name.startswith(pIdx) and name.endswith(DotExtention),
            correctFilePath
        )

def main():
    ## - input url
    url = input("url: ")
    solve(url)

if __name__ == "__main__":
    main()
