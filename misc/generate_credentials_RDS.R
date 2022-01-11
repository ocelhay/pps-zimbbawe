library(glue)
library(openssl)
library(readxl)
library(tidyverse)
rm(list = ls())

all_cred <- readxl::read_excel("/Users/olivier/Documents/Projets/LSHTM Zimbabwe/pps-zimbbawe/misc/credentials_GITIGNORE.xlsx", 
                               sheet = "cred")


for (i in 1:nrow(all_cred)) {
  user <- all_cred[i, ]
  
  cred <- serialize(
    object = list(cred_group = user$cred_group,
                  cred_user = user$cred_user,
                  cred_password = user$cred_password,
                  hospital_code = user$hospital_code,
                  data_management = user$data_management,
                  odk_url = user$odk_url,
                  odk_login = user$odk_login,
                  odk_pwd = user$odk_pwd),
    connection = NULL)
  
  encrypted_cred <- aes_cbc_encrypt(cred, key = openssl::sha256(charToRaw(user$cred_password)))
  saveRDS(encrypted_cred, glue("/Users/olivier/Documents/Projets/LSHTM Zimbabwe/pps-zimbbawe/inst/dashboard/www/cred/encrypted_cred_{user$cred_group}_{user$cred_user}.rds"))
}