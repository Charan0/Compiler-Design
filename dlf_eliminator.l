/* # is used as eplison */

%{
	#include <stdio.h>
	#include <string.h>

	int total_productions = 0;
	char productions[20][30];

	void eliminate_dfl(char production[30]){
		char non_terminal = production[0];

  		char alpha[10][10]; int alpha_count = 0;
  		char beta[10][10]; int beta_count = 0;

  		char str1[20] = "S->"; char str2[20] = "S'->";

  		str1[0] = non_terminal; str2[0] = non_terminal;

  		int flag = 0;
  		int i = 3;

  		while(production[i]){
    		if(production[i] == non_terminal){
      			i += 1;
      			int j = 0;

      			while(production[i] != '|' && production[i] != '\0'){
        			flag += 1;
        			alpha[alpha_count][j++] = production[i++];
      			}
      			alpha[alpha_count][j] = '\0';
      			alpha_count += 1;
    		}
    		else{
      			int j = 0;

      			while(production[i] != '|' && production[i] != '\0'){
        			beta[beta_count][j++] = production[i++];
      			}
      			beta[beta_count][j] = '\0';
      			beta_count += 1;
    		}
    		if(production[i]){
      			++i;
    		}
  		}

	  	if(alpha_count > 0 && beta_count > 0){
	    	char modified[] = "S\'|";
	   		modified[0] = non_terminal;

	    	for(int i = 0; i < alpha_count; ++i){
	      		strcat(str2, alpha[i]);
	      		strcat(str2, modified);
	    	}

	    	for(int i = 0; i < beta_count; ++i){
	      		if(strcmp("#", beta[i]) != 0)
	        		strcat(str1, beta[i]);
	      		strcat(str1, modified);
	    	}

	    	if(beta_count == 1 && strcmp(beta[0], "#") == 0){
	      		strcat(str2, "#");
	    	}

	    	if(str1[strlen(str1)-1] == '|'){
	      		str1[strlen(str1)-1] = '\0';
	   		}
	    	if(str2[strlen(str2)-1] == '|'){
	      		str2[strlen(str2)-1] = '\0';
	    	}
	    	printf("%s\n%s\n", str1, str2);
	  	}
	  	else {
	  		printf("%s\n", production);
	  	}
	}
%}

%%
"%"(.)* 		/* ignore it is a commment */
[A-Z].* {
	strcpy(productions[total_productions], yytext);
	++total_productions;
}
%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();

	printf("The given Grammer is : \n\n");
	for(int i = 0; i < total_productions; ++i){
		printf("%s\n", productions[i]);
	}

	printf("\n----------------------------------------------------\n");
	printf("\nCFG after eliminating Direct Left Recursions : \n\n");

	for(int i = 0; i < total_productions; ++i){
		eliminate_dfl(productions[i]);
		printf("\n");
	}

	fclose(yyin);
}
