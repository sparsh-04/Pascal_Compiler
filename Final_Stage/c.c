#include <stdio.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
int main(){
char  grade ;
bool  isready ;
int numbers[11];
int   number, i, sum,average,count ;
float   maxvalue ;

  printf("enter a number:");

  while(number != 0)
{
    if(number > 0)
{
      count= count+1;

}
    else

{
     count = count;

}
    number =  number/ 10;

}
for( i  =  2 ; i <= 10 ; i ++)
{
    if(numbers[i] <= maxvalue)
{
      maxvalue =  numbers[i] + 10;

}
}
  average =  sum / 5;

  printf("%d %d ",sum, i);
FILE *file = fopen("d.txt","w");
printf("\t\t\t\tThe Symbol table: \n");
printf("Value of grade is %c and is of type char \n ",grade);
printf("Value of isready is %d and is of type bool \n ",isready);
printf("Value of numbers[1] is %d and is of type int \n ",numbers[1]);
printf("Value of numbers[2] is %d and is of type int \n ",numbers[2]);
printf("Value of numbers[3] is %d and is of type int \n ",numbers[3]);
printf("Value of numbers[4] is %d and is of type int \n ",numbers[4]);
printf("Value of numbers[5] is %d and is of type int \n ",numbers[5]);
printf("Value of numbers[6] is %d and is of type int \n ",numbers[6]);
printf("Value of numbers[7] is %d and is of type int \n ",numbers[7]);
printf("Value of numbers[8] is %d and is of type int \n ",numbers[8]);
printf("Value of numbers[9] is %d and is of type int \n ",numbers[9]);
printf("Value of numbers[10] is %d and is of type int \n ",numbers[10]);
printf("Value of number is %d and is of type int \n ",number);
printf("Value of i is %d and is of type int \n ",i);
printf("Value of sum is %d and is of type int \n ",sum);
printf("Value of average is %d and is of type int \n ",average);
printf("Value of count is %d and is of type int \n ",count);
printf("Value of maxvalue is %f and is of type float  \n ",maxvalue);
return 0;
}