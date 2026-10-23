# 数学书籍中文译本

本仓库存放十本数学著作的中文译本 LaTeX 源码、插图和构建文件，内容涉及无穷范畴、莫尔斯理论、辛几何、弗洛尔同调与代数几何。所有书籍由根目录的 [Makefile](Makefile) 统一构建，最终 PDF 输出到 `build/`。

> 所有书籍的版权归原著者和出版方所有，此处的这些译本仅供个人学习使用。

## 书目

| 简称与源码目录 | 中文书名 | 原书名 | 作者（封面署名） |
| --- | --- | --- | --- |
| [EICT](src/EICT/) | 无穷范畴理论原本 | Elements of ∞–Category Theory | Emily Riehl、Dominic Verity |
| [FCPLT](src/FCPLT/) | 深谷范畴与皮卡–莱夫谢茨理论 | Fukaya Categories and Picard–Lefschetz Theory | Paul Seidel |
| [IIC](src/IIC/) | 无穷范畴导论 | Introduction to Infinity-Categories | Markus Land |
| [JHCST](src/JHCST/) | J-全纯曲线与辛拓扑 | J-holomorphic Curves and Symplectic Topology | Dusa McDuff、Dietmar Salamon |
| [LIFT](src/LIFT/) | 拉格朗日交弗洛尔理论 | Lagrangian Intersection Floer Theory: Anomaly and Obstruction | Kenji Fukaya、Yong-Geun Oh、Hiroshi Ohta、Kaoru Ono |
| [MTFH](src/MTFH/) | 莫尔斯理论与弗洛尔同调 | Morse Theory and Floer Homology | Michèle Audin、Mihai Damian |
| [SIHD](src/SIHD/) | 辛不变量与哈密顿动力学 | Symplectic Invariants and Hamiltonian Dynamics | Helmut Hofer、Eduard Zehnder |
| [STFH-1](src/STFH-1/) | 辛拓扑与弗洛尔同调，第一卷：辛几何与伪全纯曲线 | Symplectic Topology and Floer Homology, Volume 1: Symplectic Geometry and Pseudoholomorphic Curves | Yong-Geun Oh |
| [STFH-2](src/STFH-2/) | 辛拓扑与弗洛尔同调，第二卷：弗洛尔同调及其应用 | Symplectic Topology and Floer Homology, Volume 2: Floer Homology and its Applications | Yong-Geun Oh |
| [rising](src/rising/) | 上升之海：代数几何基础 | The Rising Sea: Foundations of Algebraic Geometry | Ravi Vakil |

## 目录布局

```text
.
├── Makefile                    统一构建入口
├── README.md                   仓库与构建说明
├── src/
│   └── <简称>/
│       ├── main.tex            该书的排版入口
│       ├── preamble.tex        宏包、字体、排版与索引样式
│       ├── chapters/           按章节拆分的源码及插图
│       └── backmatter/         附属材料和索引相关源码
└── build/
    ├── <简称>.pdf              最终译本
    └── .aux/<简称>/            该书的编译中间文件与日志
```

各书的具体拆分略有不同：部分参考文献、索引和对照表位于 `chapters/` 下的相关子目录；术语与人名宏可能集中在 `terms.tex` 或 `index-terms.tex` 中。索引样式写在各书的 TeX 源码中，编译时生成到 `build/.aux/<简称>/main.ist`。

`build/` 中的 PDF 和编译中间文件均由 Git 忽略。

## 构建环境

构建需要以下工具和字体：

- GNU Make，以及提供 `find`、`mkdir`、`mv`、`rm` 等命令的 Unix 类 shell 环境。
- XeLaTeX 和 `makeindex`，以及源码使用的 LaTeX 宏包，包括 `ctex`、`xeCJK`、`amsmath`、`amsthm`、TikZ、`tikz-cd`、`imakeidx` 等。
- 中文字体。当前各书使用 `fontset=windows`，涉及宋体（SimSun）、黑体（SimHei）、楷体（KaiTi）、仿宋（FangSong）和微软雅黑（Microsoft YaHei）等字体，需确保 XeLaTeX 能够找到它们。

如需更换字体，应同时检查各书 `main.tex` 中的 `fontset` 设置，以及 `preamble.tex` 中的显式字体设置。`rising` 还会尝试使用 `SimSun-ExtB` 或 `Source Han Serif CN` 排印部分生僻字。

## 构建与清理

所有命令均在仓库根目录执行。

| 命令 | 作用 |
| --- | --- |
| `make` 或 `make all` | 构建全部十本书 |
| `make -j3 all` | 同时构建最多三本书 |
| `make build/FCPLT.pdf` | 单独构建 FCPLT |
| `make -B build/FCPLT.pdf` | 强制重新构建 FCPLT |
| `make clean` | 删除 `build/.aux/` 中的中间文件，保留最终 PDF |
| `make distclean` | 删除整个 `build/`，包括最终 PDF |

输出文件按目录简称命名，例如 `build/FCPLT.pdf`、`build/MTFH.pdf` 和 `build/rising.pdf`。

Makefile 支持增量构建：修改某本书的 TeX 源码或插图后，只重编译相关书籍；修改根目录 Makefile 会触发全部书籍重编译。构建自动完成多轮 XeLaTeX 排版和索引生成，以更新交叉引用、目录与索引页码。MTFH 的定义页标记由 TeX 辅助文件记录，重复索引页码由 `makeindex` 合并。最终 PDF 在该书全部构建步骤成功后更新；构建失败时保留上一次成功生成的 PDF。

编译日志位于 `build/.aux/<简称>/main.log`，索引日志位于同目录的 `main.ilg`。例如，FCPLT 的编译日志为 `build/.aux/FCPLT/main.log`。执行 `make clean` 或 `make distclean` 后，这些日志也会被删除。

工具命令可通过 Make 变量 `XELATEX`、`XELATEXFLAGS` 和 `MAKEINDEX` 覆盖。

## 源码维护

- 文本文件使用 UTF-8 编码和 LF 换行，Git 的换行规则由 `.gitattributes` 管理。
- `src/` 中只保留 TeX 源码和插图；索引样式也由 TeX 源码提供。编译产物统一写入 `build/`。
- Makefile 按 `src/*/main.tex` 自动发现书籍。新增书籍应沿用现有入口布局，并在 TeX 源码中配好索引设置和编译时生成的 `main.ist`。
- 原书索引中的页码沿用原书；译本术语索引由当前构建生成，使用译本的印刷页码。
