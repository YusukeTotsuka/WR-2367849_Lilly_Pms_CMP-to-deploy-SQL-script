if not exists (select null from sys.tables where name = 'c_cdsCategories_DUL')
begin
  create table c_cdsCategories_DUL (Title varchar(3), Col_01 nvarchar(50), Col_02 nvarchar(50), Col_03 nvarchar(50), Col_04 nvarchar(2), Col_05 nvarchar(2), Col_06 nvarchar(2),
   Col_07 nvarchar(50), Col_08 nvarchar(100), Col_09 nvarchar(50), Col_10 nvarchar(20), Col_11 nvarchar(20), Col_12 nvarchar(20), Col_13 nvarchar(20), Col_14 nvarchar(2), 
   Col_15 nvarchar(20), Col_16 nvarchar(20), Col_17 nvarchar(2000), Col_18 nvarchar(20), Col_19 nvarchar(20), Col_20 nvarchar(20), Col_21 nvarchar(20), Col_22 nvarchar(20), 
   Col_23 nvarchar(20), Col_24 nvarchar(20), Col_25 nvarchar(20), Col_26 nvarchar(20), Col_27 nvarchar(20), Col_28 nvarchar(20), Col_29 nvarchar(20), Col_30 nvarchar(20), 
   Col_31 nvarchar(20), Col_32 nvarchar(20), Col_33 nvarchar(20), Col_34 nvarchar(20), Col_35 nvarchar(20), Col_36 nvarchar(20), Col_37 nvarchar(20), Col_38 nvarchar(100), 
   Col_39 nvarchar(2), Col_40 nvarchar(2), Col_41 nvarchar(2), Col_42 nvarchar(2), Col_43 nvarchar(100), Col_44 nvarchar(2), Col_45 nvarchar(2), Col_46 nvarchar(2),
   Col_47 nvarchar(2), Col_48 nvarchar(2), Col_49 nvarchar(2), Col_50 nvarchar(2), Col_51 nvarchar(2), Col_52 nvarchar(2), Col_53 nvarchar(2), Col_54 nvarchar(2), 
   Col_55 nvarchar(2), Col_56 nvarchar(2), Col_57 nvarchar(2), Col_58 nvarchar(2), Col_59 nvarchar(2), Col_60 nvarchar(2), Col_61 nvarchar(2), Col_62 nvarchar(2), 
   Col_63 nvarchar(2), Col_64 nvarchar(2), Col_65 nvarchar(2), Col_66 nvarchar(2), Col_67 nvarchar(20), Col_68 nvarchar(2), Col_69 nvarchar(2), Col_70 nvarchar(20),
   Col_71 nvarchar(2), Col_72 nvarchar(2), Col_73 nvarchar(2), Col_74 nvarchar(2), Col_75 nvarchar(2), Col_76 nvarchar(100))
end
