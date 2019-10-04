#include<stdio.h>
int main()
{
	int t0, t1, i;
	while(1)
	{
		printf("Please select a number A from (0~10):");
    	scanf("%d", &t0);
    	    	    	
    	if(t0 == 0)
    	{
    		printf("THE END");
    		break;
		}
		
    	else if (t0 < 0 || t0 > 10)
		{
        	continue;
    	}
    	
    	else
		{
			if(t0 == 7)
			{
				t1 = t0 * 2;
				printf("A * 2 = %d\n", t1);
				continue;
			}
			
			else
			{
				for(i = 0; i < t0; i++)
				printf("******%d*********\n",i);
				continue;
			}
    	}
	  return 0;
	}
}
