.PHONY: all

all: classic classic_nx classic_canary ret2libc leak

classic: classic.c
	gcc -fno-stack-protector -z execstack $< -o $@
	objdump -S $@ > $@.obj

classic_nx: classic.c
	gcc -fno-stack-protector $< -o $@
	objdump -S $@ > $@.obj

classic_canary: classic.c
	gcc -fstack-protector -z execstack $< -o $@
	objdump -S $@ > $@.obj

ret2libc: ret2libc.c
	gcc -fno-stack-protector -no-pie $< -o $@
	objdump -S $@ > $@.obj

leak: leak.c
	gcc -fno-stack-protector -no-pie $< -o $@
	objdump -S $@ > $@.obj

clean:
	-rm classic classic_nx classic_canary *.obj
