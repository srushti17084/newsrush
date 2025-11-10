import hashlib
passwords = open("samplepasswords.txt").read().splitlines()
with open("sample_hashes.txt", "w") as out:
    for p in passwords:
        md5 = hashlib.md5(p.encode()).hexdigest()
        sha1 = hashlib.sha1(p.encode()).hexdigest()
        sha256 = hashlib.sha256(p.encode()).hexdigest()
        out.write(f"{p} MD5:{md5} SHA1:{sha1} SHA256:{sha256}\n")