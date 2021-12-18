#include <asm/segment.h>
#include <errno.h>
#include <string.h>

char MyName[24];

int sys_iam(const char *name)
{
    char str[25];
    int idx = 0;
    while(idx <= 25 && str[idx] != '\0')
    {
        str[idx] = get_fs_byte(name + idx);
        idx++;
    }
    if(idx > 24)
    {
        idx = -1;
        errno = EINVAL;
    }
    else strcpy(MyName, str);
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