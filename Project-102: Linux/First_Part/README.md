# Hands-on Linux-12 : Linux Regular Expression

Purpose of the this hands-on training is to teach the students how to use regular expression on linux.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- use regular expression on linux.

## Outline

- Part 1 - Linux Regular Expression

## Part 1 - Linux Regular Expression

Linux Regular Expressions are special characters or sets of characters that help search for data and match complex patterns. The regular expression is also called ‘regexp’ and ‘regex’. They are used by many different Linux commands, like sed, awk, grep, etc. 

- Let's understand of using the different types of Regex.


- basic regular expressions:

| Symbol| Descriptions |
| -------- | ----------- |
| .	       | replaces any character |
| ^	       | matches start of string |
| $	       | matches end of string |
| *	       | matches up zero or more times the preceding character |
| \	       | Represent special characters |
| ()	   | Groups regular expressions |
| ?	       | Matches up exactly one character |

- Creta a file and name it `fruits.txt`.

```txt
apple
watermelon
orange
strawberry
blueberry
lemon
blackberry
raspberry
cranberry
kak
kek
kik
kbk
kdk
kCk
k5k
kalk
```

- Search for content containing letter ‘e’.

```bash
cat fruits.txt | grep e
```

### `.` symbol

```bash
cat fruits.txt | grep k.k
```

### `^` symbol

```bash
cat fruits.txt | grep ^b
```

### `$` symbol

```bash
cat fruits.txt | grep n$
```

### `[ ]` usage

- `[ab]` match a or b
- `[a-z]` match any lowercase letter
- `[0-9]` match any digit

```bash
cat fruits.txt | grep k[adb]k
cat fruits.txt | grep k[a-z]k
cat fruits.txt | grep k[A-Z]k
cat fruits.txt | grep k[a-zA-Z]k
cat fruits.txt | grep k[0-9]k
cat fruits.txt | grep k[a-zA-Z0-9]k
```
### `{n}` usage

- `{n}`, matches the preceding character appearing ‘n’ times exactly

```bash
cat fruits.txt | grep -E "p{2}"
```