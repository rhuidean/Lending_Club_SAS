/* Importing Raw Data Source, Lending Club */ 
%let path=C:\Users\Jason\Desktop;
filename folder1 "&path\SAS-Symposium\raw-csv.";
filename folder2 "&path\SAS-Symposium\header-removed-csv.";
libname c "&path\SAS-Symposium\sas-table";         /* just an example destination folder */
options validmemname=extend; /* to allow non-standard dataset names */
 

/* Making a list of all files in the folder1, downloaded data */
data FilesInFolder;
   length Line 8 File $300;
   List = dopen('folder1');  /* corrected the function argument */
   do Line = 1 to dnum(List); /* dnum: number of members */
        File = trim(dread(List,Line)); /* returns the name of a directory member; list is directory id #; line is sequence number of the member */
        output;
   end;
   drop list line;
run;
 
/* Creating global macro variables */ 
data _NULL_;
     set FilesInFolder end=final;
     call symput(cats('File', _N_), trim(File));     /* used CATS instead of COMPRESS (...||...) */
     call symput(cats('Name', _N_), trim(nliteral(substr(File,1,min(32, length(File)-4))))); /* inserted */
     if final then call symputx(trim('Total'), _N_); /* replaced symput by symputx */
run;


/* Macro for importing all files specified in the list and save them as datasets, SAS Tables */
%macro loop;
%do i = 1 %to &Total;
	proc import out=temp datafile="&path\SAS-Symposium\raw-csv\&&File&i" dbms=csv replace;
		getnames=no;
		datarow=2;
		guessingrows=9999;
	run;

	proc export data=temp file="&path\SAS-Symposium\header-removed-csv\&&File&i" dbms=csv replace;
		putnames=no;
	run;

  	data c.&&name&i;  /* adapted */
		LENGTH
        id               $ 4
        member_id        $ 1
        loan_amnt          8
        funded_amnt        8
        funded_amnt_inv    8
        term             $ 9
        int_rate           8
        installment        8
        grade            $ 1
        sub_grade        $ 2
        emp_title        $ 42
        emp_length       $ 9
        home_ownership   $ 8
        annual_inc         8
        verification_status $ 15
        issue_d            8
        loan_status      $ 18
        pymnt_plan       $ 1
        url              $ 1
        desc             $ 6
        purpose          $ 18
        title            $ 25
        zip_code         $ 5
        addr_state       $ 2
        dti                8
        delinq_2yrs        8
        earliest_cr_line   8
        inq_last_6mths     8
        mths_since_last_delinq   8
        mths_since_last_record   8
        open_acc           8
        pub_rec            8
        revol_bal          8
        revol_util         8
        total_acc          8
        initial_list_status $ 1
        out_prncp          8
        out_prncp_inv      8
        total_pymnt        8
        total_pymnt_inv    8
        total_rec_prncp    8
        total_rec_int      8
        total_rec_late_fee   8
        recoveries         8
        collection_recovery_fee   8
        last_pymnt_d       8
        last_pymnt_amnt    8
        next_pymnt_d       8
        last_credit_pull_d   8
        collections_12_mths_ex_med   8
        mths_since_last_major_derog   8
        policy_code        8
        application_type $ 10
        annual_inc_joint   8
        dti_joint          8
        verification_status_joint $ 12
        acc_now_delinq     8
        tot_coll_amt       8
        tot_cur_bal        8
        open_acc_6m        8
        open_act_il        8
        open_il_12m        8
        open_il_24m        8
        mths_since_rcnt_il   8
        total_bal_il       8
        il_util            8
        open_rv_12m        8
        open_rv_24m        8
        max_bal_bc         8
        all_util           8
        total_rev_hi_lim   8
        inq_fi             8
        total_cu_tl        8
        inq_last_12m       8
        acc_open_past_24mths   8
        avg_cur_bal        8
        bc_open_to_buy     8
        bc_util            8
        chargeoff_within_12_mths   8
        delinq_amnt        8
        mo_sin_old_il_acct   8
        mo_sin_old_rev_tl_op   8
        mo_sin_rcnt_rev_tl_op   8
        mo_sin_rcnt_tl     8
        mort_acc           8
        mths_since_recent_bc   8
        mths_since_recent_bc_dlq   8
        mths_since_recent_inq   8
        mths_since_recent_revol_delinq   8
        num_accts_ever_120_pd   8
        num_actv_bc_tl     8
        num_actv_rev_tl    8
        num_bc_sats        8
        num_bc_tl          8
        num_il_tl          8
        num_op_rev_tl      8
        num_rev_accts      8
        num_rev_tl_bal_gt_0   8
        num_sats           8
        num_tl_120dpd_2m   8
        num_tl_30dpd       8
        num_tl_90g_dpd_24m   8
        num_tl_op_past_12m   8
        pct_tl_nvr_dlq     8
        percent_bc_gt_75   8
        pub_rec_bankruptcies   8
        tax_liens          8
        tot_hi_cred_lim    8
        total_bal_ex_mort   8
        total_bc_limit     8
        total_il_high_credit_limit   8
        revol_bal_joint  $ 1
        sec_app_earliest_cr_line $ 1
        sec_app_inq_last_6mths $ 1
        sec_app_mort_acc $ 1
        sec_app_open_acc $ 1
        sec_app_revol_util $ 1
        sec_app_open_act_il $ 1
        sec_app_num_rev_accts $ 1
        sec_app_chargeoff_within_12_mths $ 1
        sec_app_collections_12_mths_ex_m $ 1
        sec_app_mths_since_last_major_de $ 1
        hardship_flag    $ 1
        hardship_type    $ 31
        hardship_reason  $ 21
        hardship_status  $ 9
        deferral_term      8
        hardship_amount    8
        hardship_start_date   8
        hardship_end_date   8
        payment_plan_start_date   8
        hardship_length    8
        hardship_dpd       8
        hardship_loan_status $ 18
        orig_projected_additional_accrue   8
        hardship_payoff_balance_amount   8
        hardship_last_payment_amount   8
        disbursement_method $ 9
        debt_settlement_flag $ 1
        debt_settlement_flag_date $ 8
        settlement_status $ 8
        settlement_date    8
        settlement_amount   8
        settlement_percentage   8
        settlement_term    8 ;
    LABEL
        sec_app_collections_12_mths_ex_m = "sec_app_collections_12_mths_ex_med"
        sec_app_mths_since_last_major_de = "sec_app_mths_since_last_major_derog"
        orig_projected_additional_accrue = "orig_projected_additional_accrued_interest" ;
    FORMAT
        id               $CHAR4.
        member_id        $CHAR1.
        loan_amnt        BEST5.
        funded_amnt      BEST5.
        funded_amnt_inv  BEST16.
        term             $CHAR9.
        int_rate         PERCENT7.2
        installment      BEST7.
        grade            $CHAR1.
        sub_grade        $CHAR2.
        emp_title        $CHAR42.
        emp_length       $CHAR9.
        home_ownership   $CHAR8.
        annual_inc       BEST9.
        verification_status $CHAR15.
        issue_d          DATE9.
        loan_status      $CHAR18.
        pymnt_plan       $CHAR1.
        url              $CHAR1.
        desc             $CHAR6.
        purpose          $CHAR18.
        title            $CHAR25.
        zip_code         $CHAR5.
        addr_state       $CHAR2.
        dti              BEST6.
        delinq_2yrs      BEST2.
        earliest_cr_line DATE9.
        inq_last_6mths   BEST1.
        mths_since_last_delinq BEST3.
        mths_since_last_record BEST3.
        open_acc         BEST2.
        pub_rec          BEST2.
        revol_bal        BEST7.
        revol_util       PERCENT7.2
        total_acc        BEST3.
        initial_list_status $CHAR1.
        out_prncp        BEST8.
        out_prncp_inv    BEST8.
        total_pymnt      BEST16.
        total_pymnt_inv  BEST8.
        total_rec_prncp  BEST8.
        total_rec_int    BEST8.
        total_rec_late_fee BEST14.
        recoveries       BEST8.
        collection_recovery_fee BEST15.
        last_pymnt_d     DATE9.
        last_pymnt_amnt  BEST16.
        next_pymnt_d     DATE9.
        last_credit_pull_d DATE9.
        collections_12_mths_ex_med BEST2.
        mths_since_last_major_derog BEST3.
        policy_code      BEST1.
        application_type $CHAR10.
        annual_inc_joint BEST9.
        dti_joint        BEST5.
        verification_status_joint $CHAR12.
        acc_now_delinq   BEST1.
        tot_coll_amt     BEST6.
        tot_cur_bal      BEST7.
        open_acc_6m      BEST2.
        open_act_il      BEST2.
        open_il_12m      BEST2.
        open_il_24m      BEST2.
        mths_since_rcnt_il BEST3.
        total_bal_il     BEST6.
        il_util          BEST3.
        open_rv_12m      BEST2.
        open_rv_24m      BEST2.
        max_bal_bc       BEST6.
        all_util         BEST3.
        total_rev_hi_lim BEST7.
        inq_fi           BEST2.
        total_cu_tl      BEST2.
        inq_last_12m     BEST2.
        acc_open_past_24mths BEST2.
        avg_cur_bal      BEST6.
        bc_open_to_buy   BEST6.
        bc_util          BEST5.
        chargeoff_within_12_mths BEST1.
        delinq_amnt      BEST6.
        mo_sin_old_il_acct BEST3.
        mo_sin_old_rev_tl_op BEST3.
        mo_sin_rcnt_rev_tl_op BEST3.
        mo_sin_rcnt_tl   BEST3.
        mort_acc         BEST2.
        mths_since_recent_bc BEST3.
        mths_since_recent_bc_dlq BEST3.
        mths_since_recent_inq BEST2.
        mths_since_recent_revol_delinq BEST3.
        num_accts_ever_120_pd BEST2.
        num_actv_bc_tl   BEST2.
        num_actv_rev_tl  BEST2.
        num_bc_sats      BEST2.
        num_bc_tl        BEST2.
        num_il_tl        BEST3.
        num_op_rev_tl    BEST2.
        num_rev_accts    BEST3.
        num_rev_tl_bal_gt_0 BEST2.
        num_sats         BEST2.
        num_tl_120dpd_2m BEST1.
        num_tl_30dpd     BEST1.
        num_tl_90g_dpd_24m BEST2.
        num_tl_op_past_12m BEST2.
        pct_tl_nvr_dlq   BEST4.
        percent_bc_gt_75 BEST4.
        pub_rec_bankruptcies BEST1.
        tax_liens        BEST2.
        tot_hi_cred_lim  BEST7.
        total_bal_ex_mort BEST7.
        total_bc_limit   BEST7.
        total_il_high_credit_limit BEST7.
        revol_bal_joint  $CHAR1.
        sec_app_earliest_cr_line $CHAR1.
        sec_app_inq_last_6mths $CHAR1.
        sec_app_mort_acc $CHAR1.
        sec_app_open_acc $CHAR1.
        sec_app_revol_util $CHAR1.
        sec_app_open_act_il $CHAR1.
        sec_app_num_rev_accts $CHAR1.
        sec_app_chargeoff_within_12_mths $CHAR1.
        sec_app_collections_12_mths_ex_m $CHAR1.
        sec_app_mths_since_last_major_de $CHAR1.
        hardship_flag    $CHAR1.
        hardship_type    $CHAR31.
        hardship_reason  $CHAR21.
        hardship_status  $CHAR9.
        deferral_term    BEST1.
        hardship_amount  BEST6.
        hardship_start_date DATE9.
        hardship_end_date DATE9.
        payment_plan_start_date DATE9.
        hardship_length  BEST1.
        hardship_dpd     BEST2.
        hardship_loan_status $CHAR18.
        orig_projected_additional_accrue BEST7.
        hardship_payoff_balance_amount BEST8.
        hardship_last_payment_amount BEST7.
        disbursement_method $CHAR9.
        debt_settlement_flag $CHAR1.
        debt_settlement_flag_date $CHAR8.
        settlement_status $CHAR8.
        settlement_date  DATE9.
        settlement_amount BEST8.
        settlement_percentage BEST5.
        settlement_term  BEST2. ;
    INFORMAT
        id               $CHAR4.
        member_id        $CHAR1.
        loan_amnt        BEST5.
        funded_amnt      BEST5.
        funded_amnt_inv  BEST16.
        term             $CHAR9.
        int_rate         PERCENT7.2
        installment      BEST7.
        grade            $CHAR1.
        sub_grade        $CHAR2.
        emp_title        $CHAR42.
        emp_length       $CHAR9.
        home_ownership   $CHAR8.
        annual_inc       BEST9.
        verification_status $CHAR15.
        issue_d          DATE9.
        loan_status      $CHAR18.
        pymnt_plan       $CHAR1.
        url              $CHAR1.
        desc             $CHAR6.
        purpose          $CHAR18.
        title            $CHAR25.
        zip_code         $CHAR5.
        addr_state       $CHAR2.
        dti              BEST6.
        delinq_2yrs      BEST2.
        earliest_cr_line DATE9.
        inq_last_6mths   BEST1.
        mths_since_last_delinq BEST3.
        mths_since_last_record BEST3.
        open_acc         BEST2.
        pub_rec          BEST2.
        revol_bal        BEST7.
        revol_util       PERCENT7.2
        total_acc        BEST3.
        initial_list_status $CHAR1.
        out_prncp        BEST8.
        out_prncp_inv    BEST8.
        total_pymnt      BEST16.
        total_pymnt_inv  BEST8.
        total_rec_prncp  BEST8.
        total_rec_int    BEST8.
        total_rec_late_fee BEST14.
        recoveries       BEST8.
        collection_recovery_fee BEST15.
        last_pymnt_d     DATE9.
        last_pymnt_amnt  BEST16.
        next_pymnt_d     DATE9.
        last_credit_pull_d DATE9.
        collections_12_mths_ex_med BEST2.
        mths_since_last_major_derog BEST3.
        policy_code      BEST1.
        application_type $CHAR10.
        annual_inc_joint BEST9.
        dti_joint        BEST5.
        verification_status_joint $CHAR12.
        acc_now_delinq   BEST1.
        tot_coll_amt     BEST6.
        tot_cur_bal      BEST7.
        open_acc_6m      BEST2.
        open_act_il      BEST2.
        open_il_12m      BEST2.
        open_il_24m      BEST2.
        mths_since_rcnt_il BEST3.
        total_bal_il     BEST6.
        il_util          BEST3.
        open_rv_12m      BEST2.
        open_rv_24m      BEST2.
        max_bal_bc       BEST6.
        all_util         BEST3.
        total_rev_hi_lim BEST7.
        inq_fi           BEST2.
        total_cu_tl      BEST2.
        inq_last_12m     BEST2.
        acc_open_past_24mths BEST2.
        avg_cur_bal      BEST6.
        bc_open_to_buy   BEST6.
        bc_util          BEST5.
        chargeoff_within_12_mths BEST1.
        delinq_amnt      BEST6.
        mo_sin_old_il_acct BEST3.
        mo_sin_old_rev_tl_op BEST3.
        mo_sin_rcnt_rev_tl_op BEST3.
        mo_sin_rcnt_tl   BEST3.
        mort_acc         BEST2.
        mths_since_recent_bc BEST3.
        mths_since_recent_bc_dlq BEST3.
        mths_since_recent_inq BEST2.
        mths_since_recent_revol_delinq BEST3.
        num_accts_ever_120_pd BEST2.
        num_actv_bc_tl   BEST2.
        num_actv_rev_tl  BEST2.
        num_bc_sats      BEST2.
        num_bc_tl        BEST2.
        num_il_tl        BEST3.
        num_op_rev_tl    BEST2.
        num_rev_accts    BEST3.
        num_rev_tl_bal_gt_0 BEST2.
        num_sats         BEST2.
        num_tl_120dpd_2m BEST1.
        num_tl_30dpd     BEST1.
        num_tl_90g_dpd_24m BEST2.
        num_tl_op_past_12m BEST2.
        pct_tl_nvr_dlq   BEST4.
        percent_bc_gt_75 BEST4.
        pub_rec_bankruptcies BEST1.
        tax_liens        BEST2.
        tot_hi_cred_lim  BEST7.
        total_bal_ex_mort BEST7.
        total_bc_limit   BEST7.
        total_il_high_credit_limit BEST7.
        revol_bal_joint  $CHAR1.
        sec_app_earliest_cr_line $CHAR1.
        sec_app_inq_last_6mths $CHAR1.
        sec_app_mort_acc $CHAR1.
        sec_app_open_acc $CHAR1.
        sec_app_revol_util $CHAR1.
        sec_app_open_act_il $CHAR1.
        sec_app_num_rev_accts $CHAR1.
        sec_app_chargeoff_within_12_mths $CHAR1.
        sec_app_collections_12_mths_ex_m $CHAR1.
        sec_app_mths_since_last_major_de $CHAR1.
        hardship_flag    $CHAR1.
        hardship_type    $CHAR31.
        hardship_reason  $CHAR21.
        hardship_status  $CHAR9.
        deferral_term    BEST1.
        hardship_amount  BEST6.
        hardship_start_date DATE9.
        hardship_end_date DATE9.
        payment_plan_start_date DATE9.
        hardship_length  BEST1.
        hardship_dpd     BEST2.
        hardship_loan_status $CHAR18.
        orig_projected_additional_accrue BEST7.
        hardship_payoff_balance_amount BEST8.
        hardship_last_payment_amount BEST7.
        disbursement_method $CHAR9.
        debt_settlement_flag $CHAR1.
        debt_settlement_flag_date $CHAR8.
        settlement_status $CHAR8.
        settlement_date  DATE9.
        settlement_amount BEST8.
        settlement_percentage BEST5.
        settlement_term  BEST2. ;
    INFILE "&path\SAS-Symposium\header-removed-csv\&&File&i"
        MISSOVER
        DSD 
		firstobs=2; /* DSD vs DLM */
    INPUT
        id               : $CHAR4.
        member_id        : $CHAR1.
        loan_amnt        : ?? BEST5.
        funded_amnt      : ?? BEST5.
        funded_amnt_inv  : ?? COMMA16.
        term             : $CHAR9.
        int_rate         : ?? PERCENT7.2
        installment      : ?? COMMA7.
        grade            : $CHAR1.
        sub_grade        : $CHAR2.
        emp_title        : $CHAR42.
        emp_length       : $CHAR9.
        home_ownership   : $CHAR8.
        annual_inc       : ?? COMMA9.
        verification_status : $CHAR15.
        issue_d          : ?? ANYDTDTE8.
        loan_status      : $CHAR18.
        pymnt_plan       : $CHAR1.
        url              : $CHAR1.
        desc             : $CHAR6.
        purpose          : $CHAR18.
        title            : $CHAR25.
        zip_code         : $CHAR5.
        addr_state       : $CHAR2.
        dti              : ?? COMMA6.
        delinq_2yrs      : ?? BEST2.
        earliest_cr_line : ?? ANYDTDTE8.
        inq_last_6mths   : ?? BEST1.
        mths_since_last_delinq : ?? BEST3.
        mths_since_last_record : ?? BEST3.
        open_acc         : ?? BEST2.
        pub_rec          : ?? BEST2.
        revol_bal        : ?? BEST7.
        revol_util       : ?? PERCENT7.2
        total_acc        : ?? BEST3.
        initial_list_status : $CHAR1.
        out_prncp        : ?? COMMA8.
        out_prncp_inv    : ?? COMMA8.
        total_pymnt      : ?? COMMA16.
        total_pymnt_inv  : ?? COMMA8.
        total_rec_prncp  : ?? COMMA8.
        total_rec_int    : ?? COMMA8.
        total_rec_late_fee : ?? COMMA14.
        recoveries       : ?? COMMA8.
        collection_recovery_fee : ?? COMMA15.
        last_pymnt_d     : ?? ANYDTDTE8.
        last_pymnt_amnt  : ?? COMMA16.
        next_pymnt_d     : ?? ANYDTDTE8.
        last_credit_pull_d : ?? ANYDTDTE8.
        collections_12_mths_ex_med : ?? BEST2.
        mths_since_last_major_derog : ?? BEST3.
        policy_code      : ?? BEST1.
        application_type : $CHAR10.
        annual_inc_joint : ?? COMMA9.
        dti_joint        : ?? COMMA5.
        verification_status_joint : $CHAR12.
        acc_now_delinq   : ?? BEST1.
        tot_coll_amt     : ?? BEST6.
        tot_cur_bal      : ?? BEST7.
        open_acc_6m      : ?? BEST2.
        open_act_il      : ?? BEST2.
        open_il_12m      : ?? BEST2.
        open_il_24m      : ?? BEST2.
        mths_since_rcnt_il : ?? BEST3.
        total_bal_il     : ?? BEST6.
        il_util          : ?? BEST3.
        open_rv_12m      : ?? BEST2.
        open_rv_24m      : ?? BEST2.
        max_bal_bc       : ?? BEST6.
        all_util         : ?? BEST3.
        total_rev_hi_lim : ?? BEST7.
        inq_fi           : ?? BEST2.
        total_cu_tl      : ?? BEST2.
        inq_last_12m     : ?? BEST2.
        acc_open_past_24mths : ?? BEST2.
        avg_cur_bal      : ?? BEST6.
        bc_open_to_buy   : ?? BEST6.
        bc_util          : ?? COMMA5.
        chargeoff_within_12_mths : ?? BEST1.
        delinq_amnt      : ?? BEST6.
        mo_sin_old_il_acct : ?? BEST3.
        mo_sin_old_rev_tl_op : ?? BEST3.
        mo_sin_rcnt_rev_tl_op : ?? BEST3.
        mo_sin_rcnt_tl   : ?? BEST3.
        mort_acc         : ?? BEST2.
        mths_since_recent_bc : ?? BEST3.
        mths_since_recent_bc_dlq : ?? BEST3.
        mths_since_recent_inq : ?? BEST2.
        mths_since_recent_revol_delinq : ?? BEST3.
        num_accts_ever_120_pd : ?? BEST2.
        num_actv_bc_tl   : ?? BEST2.
        num_actv_rev_tl  : ?? BEST2.
        num_bc_sats      : ?? BEST2.
        num_bc_tl        : ?? BEST2.
        num_il_tl        : ?? BEST3.
        num_op_rev_tl    : ?? BEST2.
        num_rev_accts    : ?? BEST3.
        num_rev_tl_bal_gt_0 : ?? BEST2.
        num_sats         : ?? BEST2.
        num_tl_120dpd_2m : ?? BEST1.
        num_tl_30dpd     : ?? BEST1.
        num_tl_90g_dpd_24m : ?? BEST2.
        num_tl_op_past_12m : ?? BEST2.
        pct_tl_nvr_dlq   : ?? COMMA4.
        percent_bc_gt_75 : ?? COMMA4.
        pub_rec_bankruptcies : ?? BEST1.
        tax_liens        : ?? BEST2.
        tot_hi_cred_lim  : ?? BEST7.
        total_bal_ex_mort : ?? BEST7.
        total_bc_limit   : ?? BEST7.
        total_il_high_credit_limit : ?? BEST7.
        revol_bal_joint  : $CHAR1.
        sec_app_earliest_cr_line : $CHAR1.
        sec_app_inq_last_6mths : $CHAR1.
        sec_app_mort_acc : $CHAR1.
        sec_app_open_acc : $CHAR1.
        sec_app_revol_util : $CHAR1.
        sec_app_open_act_il : $CHAR1.
        sec_app_num_rev_accts : $CHAR1.
        sec_app_chargeoff_within_12_mths : $CHAR1.
        sec_app_collections_12_mths_ex_m : $CHAR1.
        sec_app_mths_since_last_major_de : $CHAR1.
        hardship_flag    : $CHAR1.
        hardship_type    : $CHAR31.
        hardship_reason  : $CHAR21.
        hardship_status  : $CHAR9.
        deferral_term    : ?? BEST1.
        hardship_amount  : ?? COMMA6.
        hardship_start_date : ?? ANYDTDTE8.
        hardship_end_date : ?? ANYDTDTE8.
        payment_plan_start_date : ?? ANYDTDTE8.
        hardship_length  : ?? BEST1.
        hardship_dpd     : ?? BEST2.
        hardship_loan_status : $CHAR18.
        orig_projected_additional_accrue : ?? COMMA7.
        hardship_payoff_balance_amount : ?? COMMA8.
        hardship_last_payment_amount : ?? COMMA7.
        disbursement_method : $CHAR9.
        debt_settlement_flag : $CHAR1.
        debt_settlement_flag_date : $CHAR8.
        settlement_status : $CHAR8.
        settlement_date  : ?? ANYDTDTE8.
        settlement_amount : ?? COMMA8.
        settlement_percentage : ?? COMMA5.
        settlement_term  : ?? BEST2. ;
  run;
%end;
%mend loop;
 
%loop


/* Aggregating SAS tables */
libname append 'C:\Users\Jason\Desktop\SAS-Symposium\append-table';
data c.&&name20; /* Creating empty table without any columns*/
run; 

%macro append;
%do;
	proc sql;
	create table lending_append as 
	select * from c.&&name1
	%do i=2 %to &Total;
		outer union corr
		select *from c.&&name&i
	%end;
	; quit;
%end;

%mend append;

%append;

/* Explore Target Variable, loan_status */
proc freq data=append.leanding_append1;
	tables loan_status;
run;

/* Transform loan_status variable into binary categorical variable */
data append.leading_append1;
	set lending_append;
	if loan_status in ('Charged Off','Late (31-120 days)','Default') then default=0 ;
	if loan_status in = 'Fully Paid' then default=1 ;
	drop loan_status;
run; 


