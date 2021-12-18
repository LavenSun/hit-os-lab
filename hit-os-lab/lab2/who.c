#include <asm/segment.h>
#include <errno.h>
#include <string.h>

char MyName[24];

int sys_iam(const char *name)
{
    char str;
    int idx = 0;
    while((str = get_fs_byte(name + idx)) != '\0')
    {
	    if(idx > 24)
	    {
            idx = -1;
            errno = EINVAL;
            break;
        }
        MyName[idx++] = str;
    }
    return idx;
}

int sys_whoami(char *name, unsigned int sz)
{
    int len = strlen(MyName);
    int i = 0;
    if(len > sz)
    {
        len = -1;
	    errno = EINVAL;
    }
    else
    {
	    for(; i < len; i++)
	        put_fs_byte(MyName[i], name + i);
    }
    return len;
}