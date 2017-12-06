##Drafted by Aramis Calderon (email: aramis.calderon@halfaker.com/ phone: 7608055923)
Feature: Adapt Corp Email BIO to VET360 Address data table
		As Department of Veterans Affairs Enterprise, I want to convert Email Address records in VBA Corp to VET360 Email records schema. 

	Constraints:
	- Email addresses in the VBA Corp are stored in physical address Table (PTCPNT_ADDRS). 

	GoldenGate Assumptions:
	- Corp-CDC-Staging-Table filter will only provide an Email specific DB view/table.
	- Corp-CDC-Staging-Table Email specific DB view/table will only expose mapped fields that are required for changes.
	- Corp-CDC-Staging-Table will ONLY stage records where PTCPNT_ADDRS_TYPE_NM equals "EMAIL".
    - Adapter will not check if a record is active and belongs to a living veteran without a fiduciary.	
    - Corp-CDC-Staging-Table will include Corp MVI staging table to make sure Adapter does not touch records awaiting synch to MVI. 
	
    Field Mappings:
	- Records from Corp are PTCPNT_ADDRS records with a PTCPNT_ADDRS_TYPE_NM equal to "EMAIL"
	- VET360 record is created with effectiveStartDate matching Corp EFCTV_DT.
	- Corp EMAIL_ADDRS_TXT populates VET360 emailAddressText field.
	- Corp EFCTV_DT populates VET360 effectiveStartDate field.
	- Corp JRN_DT populates VET360 sourceDate field.
	- Corp JRN_OBJ_ID populates VET360 orginatingSourceSys field.
	- Corp JRN_USER_ID populates VET360 sourceSysUser field.
	- VET360 sourceSystem value will be derived from header data.
		
 	Background: Veteran phone record from Corp PTCPNT_ADDRS table to VET360 adapted table.
		Given VET360 BIO Schema for email
			| Attribute Name                    | Coded Value            | Mandatory/Optional | Type (length)   | Length | Standard | common/core | IOC |
			| Effective Start Date              | effectiveStartDate     | Mandatory          | Date            |        | ISO 8601 |             |		|
			| Effective End Date                | effectiveEndDate       | Optional           | Date            |        | ISO 8601 |             |		|
			| Email Address                     | emailAddressText       | Mandatory          | String          | 255    | none     |             |		|
			| Email Permission To Use Indicator | emailPermInd           | Optional           | Boolean         |        | none     |             |		|
			| Email Delivery Status Code        | emailStatusCode        | Optional           | Enumerated List |        | none     |             |		|
			| Confirmation Date                 | emailConfDate          | Optional           | Date            |        | ISO 8601 |             |		|
			| Source System                     | sourceSystem           | Optional           | String          | 255    | none     | core        |		|
			| Originating Source System         | orginatingSourceSys    | Optional           | String          | 255    | none     | core        |		|
			| Source System User                | sourceSysUser          | Optional           | String          | 255    | none     | core        |		|
			| Source Date                       | sourceDate             | Mandatory          | Date/Time (GMT) |        | ISO 8601 | core        |		|
			| Email ID                          | emailId				 | Optional           | String          |        | none     |             |		|
		
		Given VBA Corp Schema for PTCPNT_ADDRS
			| Attribute Name						            | Column Name			    | Mandatory/Optional | Type         | Length |	
			| PARTICIPANT ADDRESS TYPE NAME 		            | PTCPNT_ADDRS_TYPE_NM      | Mandatory			 | VARCHAR2 	|	50  |						
			| PARTICIPANT ADDRESS EFFECTIVE DATE	            | EFCTV_DT 			        | Mandatory			 | DATE		    |		|
			| PARTICIPANT ADDRESS ONE TEXT			            | ADDRS_ONE_TXT 		    | Optional			 | VARCHAR2 	|	35	|
			| PARTICIPANT ADDRESS TWO TEXT			            | ADDRS_TWO_TXT 		    | Optional			 | VARCHAR2 	|	35	|
			| PARTICIPANT ADDRESS THREE TEXT		            | ADDRS_THREE_TXT 		    | Optional			 | VARCHAR2 	|	35	|
			| PARTICIPANT ADDRESS CITY NAME			            | CITY_NM 	                | Optional	         | VARCHAR2     |	30	|
			| PARTICIPANT ADDRESS COUNTY NAME		            | COUNTY_NM 			    | Optional			 | VARCHAR2  	|	30	|
			| PARTICIPANT ADDRESS ZIP CODE PREFIX NUMBER        | ZIP_PREFIX_NBR 	        | Optional			 | VARCHAR2 	|	5	|
			| PARTICIPANT ADDRESS ZIP CODE FIRST SUFFIX NUMBER  | ZIP_FIRST_SUFFIX_NBR      | Optional			 | VARCHAR2 	|	4	|
			| PARTICIPANT ADDRESS ZIP CODE SECOND SUFFIX NUMBER | ZIP_SECOND_SUFFIX_NBR     | Optional			 | VARCHAR2 	|	2	|
			| PARTICIPANT ADDRESS END DATE			            | END_DT 			        | Optional			 | DATE      	|		|
			| PARTICIPANT ADDRESS POSTAL CODE		            | POSTAL_CD 			    | Optional			 | VARCHAR2     |	2	|
			| PARTICIPANT ADDRESS COUNTRY TYPE NAME	            | CNTRY_TYPE_NM 	        | Optional			 | VARCHAR2 	|	50	|
			| PARTICIPANT ADDRESS BAD ADDRESS INDICATOR         | BAD_ADDRS_IND 	        | Optional			 | VARCHAR2 	|	1	|
			| PARTICIPANT ADDRESS MILITARY POSTAL TYPE CODE     | EMAIL_ADDRS_TXT 		    | Optional			 | VARCHAR2     |  254	|
			| PARTICIPANT ADDRESS MILITARY POSTAL TYPE CODE     | MLTY_POSTAL_TYPE_CD 	    | Optional			 | VARCHAR2 	|	12	|
			| PARTICIPANT ADDRESS MILITARY POST OFFICE TYPE CODE| MLTY_POST_OFFICE_TYPE_CD  | Optional			 | VARCHAR2     |	12	|
			| PARTICIPANT ADDRESS FOREIGN POSTAL CODE           | FRGN_POSTAL_CD            | Optional           | VARCHAR2     |	16	|
			| PARTICIPANT ADDRESS PROVINCE NAME                 | PRVNC_NM                  | Optional           | VARCHAR2     |	35	|
			| PARTICIPANT ADDRESS TERRITORY NAME                | TRTRY_NM                  | Optional           | VARCHAR2     |  	35	|      
			| JOURNAL DATE                                      | JRN_DT                    | Mandatory          | DATE        	|          
			| JOURNAL LOCATION IDENTIFIER                       | JRN_LCTN_ID               | Mandatory          | VARCHAR2     |	4	|          
			| JOURNAL USER IDENTIFIER                           | JRN_USER_ID               | Mandatory          | VARCHAR2 	|	50	|          
			| JOURNAL STATUS TYPE CODE                          | JRN_STATUS_TYPE_CD        | Mandatory          | VARCHAR2     |	12	|         
			| JOURNAL OBJECT IDENTIFIER                         | JRN_OBJ_ID                | Mandatory          | VARCHAR2     | 	32	|         
			| PARTICIPANT ADDRESS IDENTIFIER                    | PTCPNT_ADDRS_ID           | Mandatory          | NUMBER   	|  	15	|        
			| GROUP1 VERIFIED TYPE CODE                         | GROUP1_VERIFD_TYPE_CD     | Optional           | VARCHAR2 	|  	12	|        
			| JOURNAL EXTERNAL USER IDENTIFER                   | JRN_EXTNL_USER_ID         | Optional           | VARCHAR2 	|   50	|       
			| JOURNAL EXTERNAL KEY TEXT                         | JRN_EXTNL_KEY_TXT         | Optional           | VARCHAR2 	|   50	|	          
			| JOURNAL EXTERNAL APPLICATION NAME                 | JRN_EXTNL_APPLCN_NM       | Optional           | VARCHAR2 	|   50	|          
			| JOURNAL DATE                                      | CREATE_DT                 | Optional           | DATE       	|   	|          
			| JOURNAL LOCATION IDENTIFIER                       | CREATE_LCTN_ID            | Optional           | VARCHAR2  	|    4	|         
			| JOURNAL USER IDENTIFIER                           | CREATE_USER_ID            | Optional           | VARCHAR2     |   50	|         
			| JOURNAL OBJECT IDENTIFIER                         | CREATE_OBJ_ID             | Optional           | VARCHAR2     |   32	|          
			| JOURNAL EXTERNAL USER IDENTIFER                   | CREATE_EXTNL_USER_ID      | Optional           | VARCHAR2     |   50	|          
			| JOURNAL EXTERNAL KEY TEXT                         | CREATE_EXTNL_KEY_TXT      | Optional           | VARCHAR2 	|   50	|          
			| JOURNAL EXTERNAL APPLICATION NAME                 | CREATE_EXTNL_APPLCN_NM    | Optional           | VARCHAR2     |   50	|    
			| PARTICIPANT ADDRESS SHARED ADDRESS INDICATOR      | SHARED_ADDRS_IND          | Mandatory          | VARCHAR2     |   1	|
			
		Given the system has defined a valid Email Address	
			| attrbuteName			    | value              | 	
			| PTCPNT_ADDRS_TYPE_NM      | EMAIL			  	 |						
			| EFCTV_DT 			        | Today-30			 | 
			| ADDRS_ONE_TXT 		    | null			 	 | 
			| ADDRS_TWO_TXT 		    | null			 	 | 
			| ADDRS_THREE_TXT 		    | null			 	 | 
			| CITY_NM 	                | null	         	 | 
			| COUNTY_NM 			    | null			 	 | 
			| ZIP_PREFIX_NBR 	        | null			 	 | 
			| ZIP_FIRST_SUFFIX_NBR      | null			 	 | 
			| ZIP_SECOND_SUFFIX_NBR     | null			 	 | 
			| END_DT 			        | null			 	 | 
			| POSTAL_CD 			    | null				 | 
			| CNTRY_TYPE_NM 	        | null			 	 | 
			| BAD_ADDRS_IND 	        | null			     | 
			| EMAIL_ADDRS_TXT 		    | john.smith@va.gov	 | 
			| MLTY_POSTAL_TYPE_CD 	    | null			 	 |
			| MLTY_POST_OFFICE_TYPE_CD  | null				 |
			| FRGN_POSTAL_CD            | null           	 |
			| PRVNC_NM                  | null           	 | 
			| TRTRY_NM                  | null           	 |   
			| JRN_DT                    | Today-9            | 
			| JRN_LCTN_ID               | 137                |        
			| JRN_USER_ID               | vnkvail          	 |  
			| JRN_STATUS_TYPE_CD        | U          	 	 |        
			| JRN_OBJ_ID                | wuperson           |         
			| PTCPNT_ADDRS_ID           | 3295          	 |         
			| GROUP1_VERIFD_TYPE_CD     | null           	 |       
			| JRN_EXTNL_USER_ID         | null           	 |    
			| JRN_EXTNL_KEY_TXT         | null           	 |          
			| JRN_EXTNL_APPLCN_NM       | null           	 |          
			| CREATE_DT                 | null           	 |         
			| CREATE_LCTN_ID            | null           	 |         
			| CREATE_USER_ID            | null           	 |          
			| CREATE_OBJ_ID             | null           	 |         
			| CREATE_EXTNL_USER_ID      | null           	 |   
			| CREATE_EXTNL_KEY_TXT      | null           	 |    
			| CREATE_EXTNL_APPLCN_NM    | null           	 |     
			| SHARED_ADDRS_IND          | N              	 | 
			
	Scenario: Corp Address Record of Type Email has no Email Address
		Given the following person email DIO received from the Corp-CDC-Staging-Table
			|PTCPNT_ADDRS_TYPE_NM |EFCTV_DT   | ADDRS_ONE_TXT | ADDRS_TWO_TXT | ADDRS_THREE_TXT | CITY_NM | COUNTY_NM | ZIP_PREFIX_NBR | ZIP_FIRST_SUFFIX_NBR | ZIP_SECOND_SUFFIX_NBR | END_DT | POSTAL_CD | CNTRY_TYPE_NM | BAD_ADDRS_IND | EMAIL_ADDRS_TXT         | MLTY_POSTAL_TYPE_CD        | MLTY_POST_OFFICE_TYPE_CD | FRGN_POSTAL_CD | PRVNC_NM | TRTRY_NM | JRN_DT    | JRN_LCTN_ID | JRN_USER_ID | JRN_STATUS_TYPE_CD | JRN_OBJ_ID | PTCPNT_ADDRS_ID | GROUP1_VERIFD_TYPE_CD | JRN_EXTNL_USER_ID | JRN_EXTNL_KEY_TXT | JRN_EXTNL_APPLCN_NM | CREATE_DT | CREATE_LCTN_ID | CREATE_USER_ID | CREATE_OBJ_ID | CREATE_EXTNL_USER_ID | CREATE_EXTNL_KEY_TXT | CREATE_EXTNL_APPLCN_NM | SHARED_ADDRS_IND | 
			|EMAIL		          |Today-10   |               | 		 	  |      		    | 		  |      	  |		           | 			          |                       |        |           |      	       |  			   |	            		 |	                          |				             | 		         |          |          |   Today-10|  301        |VHALASFINKED |  I                 | secauser   |  4422           |                       |                   |                   |                     |           |                |                |               |                      |                      |                        |  		N        |			
		When EMAIL_ADDRS_TXT is null
		Then the Adapter will drop record and send "COMPLETED_NOOP" to Corp-CDC-Staging-Table
		
	Scenario: Corp Address Record of Type Email has malformed Email Address 
		Given the following Corp person email DIO received from the Corp-CDC-Staging-Table
			| PTCPNT_ADDRS_TYPE_NM |EFCTV_DT   | ADDRS_ONE_TXT | ADDRS_TWO_TXT | ADDRS_THREE_TXT | CITY_NM | COUNTY_NM | ZIP_PREFIX_NBR | ZIP_FIRST_SUFFIX_NBR | ZIP_SECOND_SUFFIX_NBR | END_DT | POSTAL_CD | CNTRY_TYPE_NM | BAD_ADDRS_IND | EMAIL_ADDRS_TXT         | MLTY_POSTAL_TYPE_CD        | MLTY_POST_OFFICE_TYPE_CD | FRGN_POSTAL_CD | PRVNC_NM | TRTRY_NM | JRN_DT    | JRN_LCTN_ID | JRN_USER_ID | JRN_STATUS_TYPE_CD | JRN_OBJ_ID | PTCPNT_ADDRS_ID | GROUP1_VERIFD_TYPE_CD | JRN_EXTNL_USER_ID | JRN_EXTNL_KEY_TXT | JRN_EXTNL_APPLCN_NM | CREATE_DT | CREATE_LCTN_ID | CREATE_USER_ID | CREATE_OBJ_ID | CREATE_EXTNL_USER_ID | CREATE_EXTNL_KEY_TXT | CREATE_EXTNL_APPLCN_NM | SHARED_ADDRS_IND | 
			|  EMAIL               |Today-120  |               | 		 		 |      		   | 		 |      	 |		          | 			         |                       |        |           |      	      |  			  |	crapEmai@@c.o.m.edu	    |	                         |				            | 		         |          |          |   Today-1 |  301        |VHALASFINKED |  U                 | secauser   |  4422           |                       |                   |                   |                     |           |                |                |               |                      |                      |                        |  		Y        |			
		When EMAIL_ADDRS_TXT is not NULL
		Then the Adapter will convert the Email to the following VET360 BIO and send to Maintenance-Endpoint which will return "RECEIVED_ERROR_QUEUE" to Corp-CDC-Staging-Table
			| mailAddressText    | sourceDate | sourceSystem | orginatingSourceSys | sourceSysUser |effectiveStartDate|
			| crapEmai@@c.o.m.edu |  Today-1  |"Corp"        |   secauser           |  VHALASFINKED|  Today-120       |
			
	Scenario: Corp Address Record of Type Email has a valid Email Address 
		Given the following Corp person email DIO received from the Corp-CDC-Staging-Table
			|PTCPNT_ADDRS_TYPE_NM |EFCTV_DT   | ADDRS_ONE_TXT | ADDRS_TWO_TXT | ADDRS_THREE_TXT | CITY_NM | COUNTY_NM | ZIP_PREFIX_NBR | ZIP_FIRST_SUFFIX_NBR | ZIP_SECOND_SUFFIX_NBR | END_DT | POSTAL_CD | CNTRY_TYPE_NM | BAD_ADDRS_IND | EMAIL_ADDRS_TXT         | MLTY_POSTAL_TYPE_CD        | MLTY_POST_OFFICE_TYPE_CD | FRGN_POSTAL_CD | PRVNC_NM | TRTRY_NM | JRN_DT    | JRN_LCTN_ID | JRN_USER_ID | JRN_STATUS_TYPE_CD | JRN_OBJ_ID   | PTCPNT_ADDRS_ID | GROUP1_VERIFD_TYPE_CD | JRN_EXTNL_USER_ID | JRN_EXTNL_KEY_TXT | JRN_EXTNL_APPLCN_NM | CREATE_DT | CREATE_LCTN_ID | CREATE_USER_ID | CREATE_OBJ_ID | CREATE_EXTNL_USER_ID | CREATE_EXTNL_KEY_TXT | CREATE_EXTNL_APPLCN_NM | SHARED_ADDRS_IND | 
			| EMAIL		          |Today-180	 |               | 		 		 |      		   | 		 |      	 |		          | 			         |                       |        |           |      	      |  			  |	good.Email@yahoo.com    |	                         |				            | 		         |          |          |   Today-21|  325        |VICCPIAZ     |  U                 | SHARE  - CADD|    22           |                       |                   |                   |                     |           |                |                |               |                      |                      |                        |  		N          |			
		When EMAIL_ADDRS_TXT is not NULL
		Then the Adapter will convert the Email to the following VET360 BIO and send through Maintenance-Endpoint which will return a "RECEIVED" response to Corp-CDC-Staging-Table
			| emailAddressText    | sourceDate | sourceSystem | orginatingSourceSys | sourceSysUser |effectiveStartDate|
			| good.Email@yahoo.com |  Today-21  |"Corp"        |   secauser           |  VHALASFINKED|  Today-180       |

	Scenario: Updating an Email record in VET360 
		Given the following person Email record DIO received from the Corp-CDC-Staging-Table
			|PTCPNT_ADDRS_TYPE_NM |EFCTV_DT   | ADDRS_ONE_TXT | ADDRS_TWO_TXT | ADDRS_THREE_TXT | CITY_NM | COUNTY_NM | ZIP_PREFIX_NBR | ZIP_FIRST_SUFFIX_NBR | ZIP_SECOND_SUFFIX_NBR | END_DT | POSTAL_CD | CNTRY_TYPE_NM | BAD_ADDRS_IND | EMAIL_ADDRS_TXT         | MLTY_POSTAL_TYPE_CD        | MLTY_POST_OFFICE_TYPE_CD | FRGN_POSTAL_CD | PRVNC_NM | TRTRY_NM | JRN_DT    | JRN_LCTN_ID | JRN_USER_ID | JRN_STATUS_TYPE_CD | JRN_OBJ_ID   | PTCPNT_ADDRS_ID | GROUP1_VERIFD_TYPE_CD | JRN_EXTNL_USER_ID | JRN_EXTNL_KEY_TXT | JRN_EXTNL_APPLCN_NM | CREATE_DT | CREATE_LCTN_ID | CREATE_USER_ID | CREATE_OBJ_ID | CREATE_EXTNL_USER_ID | CREATE_EXTNL_KEY_TXT | CREATE_EXTNL_APPLCN_NM | SHARED_ADDRS_IND | 
			| EMAIL		         |Today       |               | 		 	  |      		    | 		  |      	  |		           | 			          |                       |        |           |      	       |  		       |	new.Email@yahoo.com    |	                         |				            | 		         |          |          |   Today-21|  325        |VICCPIAZ     |  I                 | SHARE  - CADD|    22           |                       |                   |                   |                     |           |                |                |               |                      |                      |                        |  		N          |			
		When Email record DIO PTCPNT_ID received from the Corp-CDC-Staging-Table correlates to VET360Id 
		And the emailAddressText is equal to EMAIL_ADDRS_TXT
		Then the Adapter will convert the Email to the following VET360 BIO, does not populate effectiveStartDate with EFCTV_DT, and send through Maintenance-Endpoint which will return "RECEIVED_ERROR_QUEUE" to Corp-CDC-Staging-Table
			| emailAddressText    | sourceDate | sourceSystem | orginatingSourceSys | sourceSysUser |effectiveStartDate|
			| new.Email@yahoo.com |  Today     | "Corp"       |   secauser          |  VHALASFINKED |  Today-180       |
		
	Scenario: End-date an Email record in VET360 
		Given the following person Email record DIO received from the Corp-CDC-Staging-Table
			|PTCPNT_ADDRS_TYPE_NM |EFCTV_DT   | ADDRS_ONE_TXT | ADDRS_TWO_TXT | ADDRS_THREE_TXT | CITY_NM | COUNTY_NM | ZIP_PREFIX_NBR | ZIP_FIRST_SUFFIX_NBR | ZIP_SECOND_SUFFIX_NBR | END_DT | POSTAL_CD | CNTRY_TYPE_NM | BAD_ADDRS_IND | EMAIL_ADDRS_TXT                | MLTY_POSTAL_TYPE_CD        | MLTY_POST_OFFICE_TYPE_CD | FRGN_POSTAL_CD | PRVNC_NM | TRTRY_NM | JRN_DT    | JRN_LCTN_ID | JRN_USER_ID | JRN_STATUS_TYPE_CD | JRN_OBJ_ID   | PTCPNT_ADDRS_ID | GROUP1_VERIFD_TYPE_CD | JRN_EXTNL_USER_ID | JRN_EXTNL_KEY_TXT | JRN_EXTNL_APPLCN_NM | CREATE_DT | CREATE_LCTN_ID | CREATE_USER_ID | CREATE_OBJ_ID | CREATE_EXTNL_USER_ID | CREATE_EXTNL_KEY_TXT | CREATE_EXTNL_APPLCN_NM | SHARED_ADDRS_IND | 
			| EMAIL		          |Today-30   |               | 		 	  |      		    | 		  |      	  |		           | 			          |                       |Today   |           |      	      |  		       | doesn't_matter.Email@yahoo.com |	                         |				            | 		         |          |          |   Today-21|  325        |VICCPIAZ     |  I                 | SHARE  - CADD|    22           |                       |                   |                   |                     |           |                |                |               |                      |                      |                        |  		N          |			
		When Email record DIO PTCPNT_ID received from the Corp-CDC-Staging-Table correlates to VET360Id 
		And has an END_DT not NULL
		Then the Adapter will convert the Email to the following VET360 BIO and send through Maintenance-Endpoint which will return "RECEIVED_ERROR_QUEUE" to Corp-CDC-Staging-Table
			| emailAddressText    			 | sourceDate | sourceSystem | orginatingSourceSys | sourceSysUser |effectiveStartDate|effectiveEndDate|
			| doesn't_matter.Email@yahoo.com |  Today     |"Corp"        |   secauser          |  VHALASFINKED |  Today-180       | Today          |
			
	Scenario: End-date an Email record with a different Email value in VET360 
		Given the following person Email record DIO received from the Corp-CDC-Staging-Table
			|PTCPNT_ADDRS_TYPE_NM |EFCTV_DT   | ADDRS_ONE_TXT | ADDRS_TWO_TXT | ADDRS_THREE_TXT | CITY_NM | COUNTY_NM | ZIP_PREFIX_NBR | ZIP_FIRST_SUFFIX_NBR | ZIP_SECOND_SUFFIX_NBR | END_DT | POSTAL_CD | CNTRY_TYPE_NM | BAD_ADDRS_IND | EMAIL_ADDRS_TXT                | MLTY_POSTAL_TYPE_CD        | MLTY_POST_OFFICE_TYPE_CD | FRGN_POSTAL_CD | PRVNC_NM | TRTRY_NM | JRN_DT    | JRN_LCTN_ID | JRN_USER_ID | JRN_STATUS_TYPE_CD | JRN_OBJ_ID   | PTCPNT_ADDRS_ID | GROUP1_VERIFD_TYPE_CD | JRN_EXTNL_USER_ID | JRN_EXTNL_KEY_TXT | JRN_EXTNL_APPLCN_NM | CREATE_DT | CREATE_LCTN_ID | CREATE_USER_ID | CREATE_OBJ_ID | CREATE_EXTNL_USER_ID | CREATE_EXTNL_KEY_TXT | CREATE_EXTNL_APPLCN_NM | SHARED_ADDRS_IND | 
			| EMAIL		          |Today-30   |               | 		 	  |      		    | 		  |      	  |		           | 			          |                       |Today  |           |      	      |  		       | different.Email@yahoo.com |	                         |				            | 		         |          |          |   Today-21|  325        |VICCPIAZ     |  I                 | SHARE  - CADD|    22           |                       |                   |                   |                     |           |                |                |               |                      |                      |                        |  		N          |			
		When Email record DIO PTCPNT_ID received from the Corp-CDC-Staging-Table correlates to VET360Id 
		And the emailAddressText does not equal to EMAIL_ADDRS_TXT
		Then the Adapter will convert the Email to the following VET360 BIO and send through Maintenance-Endpoint which will return "RECEIVED_ERROR_QUEUE" to Corp-CDC-Staging-Table
			| emailAddressText    			 | sourceDate | sourceSystem | orginatingSourceSys | sourceSysUser |effectiveStartDate |effectiveEndDate   |
			| same.Email@yahoo.com           |  Today     |"Corp"        |   secauser           |  VHALASFINKED   |  Today-180     | Today             |
			
				
			
			