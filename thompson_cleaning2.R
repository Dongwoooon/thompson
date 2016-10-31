library(dplyr)
library(sqldf)

data <- read.csv("J:\\������\\thompson_clean3.csv")

data <- subset(data, select = -c(X.2, X.1, X_1, X_1.1, X, Capped_Participating_Preferred, 
                                 Company_Accountant, Company_Area_Code, Company_Legal_Counsel, Company_MoneyTree_Region,
                                 Company_Number_of_Employees, Company_Zip_Code, Company_Zip_Code_Branch_Office, Deal_Value_USD_Mil, 
                                 Debt_Amount_USD_Mil, Firm__First_Investment_Date, Firm__Last_Investment_Date, Firm__Total_Number_of_Deals,
                                 Firm_Latest_Fund_Closing_Date, Firm_Latest_Fund_Name, Firm_Latest_Fund_Size_USD_Mil, Firm_MoneyTree_Region,
                                 Firm_Nation, Firm_Preferred_Investment_Role, Firm_Preferred_Maximum_Investment_USD_Mil,
                                 Firm_Preferred_Minimum_Investment_USD_Mil))

               
data <- subset(data, select = -c(Firm_Industry_Focus, Firm_Status, Firm_Zip_Code, Fund__First_Investment_Date,
                                 Fund__Last_Investment_Date, Fund__Total_Number_of_Deals, Fund_City, Fund_Founded_Year,
                                 Fund_Industry_Focus, Fund_Investor_Type, Fund_Nation, Fund_Size_USD_Mil, Fund_Size_Category_USD_Mil,
                                 Fund_Size_Target_USD_Mil, Fund_Stage, Fund_Status, Fund_Type, Fund_Zip_Code, Investment_Date_1,
                                 Investment_Location__World_Sub_Location))

data <- subset(data, select = -c(MoneyTree_Industry, NAIC_Code, NAIC_Description, New_or_Follow_on_Investment, No_of_Firms_in_Total,
                                 No_of_Funds_Managed_by_Firm, No_of_Funds_at_Investment_Date, No_of_Funds_in_Total,
                                 SIC_Code, SIC_Description, Total_Estimated_Equity_Invested_by_Firm_to_Date_USD_Mil, Total_Estimated_Equity_Invested_by_Fund_to_Date_USD_Mil,
                                 Total_Known_Equity_Invested_by_Firm_to_Date_USD_Mil, Total_Known_Equity_Invested_by_Fund_to_Date_USD_Mil, Total_Number_of_Companies_Invested_in_by_Firm,
                                 Total_Number_of_Companies_Invested_in_by_Fund, Type_of_Preferred_Stock, Valuation_Direction))

# IT�� �̾ƿ;���
IT <- sqldf("select * from data where Company_VE_Primary_Industry_Class like 'Information%'")
IT <- subset(IT, Company_Technology_Application!='Non-Internet Related')

# cleantech, nanotech ���� �Ž����� Ȯ�� ����
Cleanano <- subset(IT, Company_Technology_Application=='Clean Technology' | Company_Technology_Application=='Nanotechnology')
arng.clna<-arrange(Cleanano, Company_Technology_Application, Company_VE_Primary_Industry_Sub_Group_3)
# Cleanano ���� �� ���ͳ��̶� ����� ���� �׷� ����
IT2 <- subset(IT, Company_Technology_Application!='Clean Technology' & Company_Technology_Application!='Nanotechnology')

# B2B ȸ��� �� �¾Ƽ� ����
IT3 <- subset(IT2, Company_Primary_Customer_Type!='Business' & Company_Technology_Application!='Business Process Outsourcing (BPO)')  

# ���� �� �ֳ� ����
unique(IT3[22]) 

# ���ͳ� �޸��Ŷ� e-commerce�� �߷�������
IT4 <- sqldf("select * from IT3 where Company_VE_Primary_Industry_Sub_Group_2 like 'Internet%'
             OR Company_VE_Primary_Industry_Sub_Group_2 like 'E-Commerce%'")
### �ϰ� �ô��� IT3[21]�� internet specific�� ��� �����ų�... ���� �̰ɷ� �Ұ�

# IPO �� ��鸸 �����
IT.ipo <- subset(IT4, IT4[9]!='-')
count(unique(IT.ipo[13]))   # ipo ȸ�� �� ���� - 344��

write.csv(IT4, "J:\\������\\internet.csv")
write.csv(IT.ipo, "J:\\������\\internet_ipo.csv")