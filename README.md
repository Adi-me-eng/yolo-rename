# yolo-rename 💀

**Rename your files and folders into pure chaos.**
Because why have `Documents/Taxes2023.pdf` when you could have `l0s798gkjsj/7xkq8m2a.o9`?

> **WARNING**: This script *will* absolutely destroy recognizable file names. Use only on your own machine, in folders you don't mind corrupting into nonsense.

---

## Installation

```bash
# Clone the madness
git clone https://github.com/sygmoyd/yolo-rename.git
cd yolo-rename

# Make it executable
chmod +x yolo-rename.sh

# (Optional) Install globally
sudo cp yolo-rename.sh /usr/local/bin/yolo-rename
```

---

## Usage

**Basic:**

```bash
yolo-rename ~/Documents
```

This will recursively rename everything in `~/Documents` into random garbage names.

**Dry run (see the chaos before committing):**

```bash
yolo-rename ~/Documents --dry-run
```

**Limit recursion depth:**

```bash
yolo-rename ~/Documents --max-depth 2
```

---

## Example

Before:

```
/home/user/Documents
├── Resume.pdf
├── Taxes2023.pdf
└── Projects
    ├── report.docx
    └── budget.xlsx
```

After:

```
/home/user/Documents
├── q9k28l8.aa
├── 7xkq8m2a.o9
└── zj8s2d5
    ├── 0a3m9lq.c2
    └── 93kdm2q.f5
```

Dry run output:

```
[DRY] file : /home/user/Documents/Resume.pdf -> /home/user/Documents/q9k28l8.aa
[DRY] file : /home/user/Documents/Taxes2023.pdf -> /home/user/Documents/7xkq8m2a.o9
[DRY] dir  : /home/user/Documents/Projects -> /home/user/Documents/zj8s2d5
...
```

---

## Disclaimer

This script is **irreversible**. Use it only on folders you can afford to lose all readable names in. If you point it at your home folder, say goodbye to sanity.

**You have been warned.**
