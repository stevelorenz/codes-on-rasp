import sys
sys.path.append('../')

from tmp64 import TMP64


def main():
    tmp = TMP64()
    tmpValue = tmp.readTmpValue()
    print(tmpValue)

if __name__ == "__main__":
    main()
