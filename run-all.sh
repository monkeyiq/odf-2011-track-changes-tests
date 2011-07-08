#!/bin/bash

>| /tmp/regression-output.txt
date >> /tmp/regression-output.txt

cd ./attribute-change
./attribute_change::Test.t     2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./change-element-type
./change_element_type::Test.t  2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./delta-merge
./deltamerge::Test.t           2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./move-para
./move_para::Test.t            2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./para-add-delete
./para_and_delete::Test.t      2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./para-split-and-merge
./para_split_and_merge::Test.t  2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./pcdata-add-and-remove
./pcdata_add_and_remove::Test.t 2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./sans-change-tracking
./sans_change_tracking::Test.t  2>&1 | tee -a /tmp/regression-output.txt
cd -

cd ./tables
./tables::Test.t   2>&1 | tee -a /tmp/regression-output.txt
cd -

echo " "
echo "Log is at: /tmp/regression-output.txt"
echo " "

if grep -i error /tmp/regression-output.txt >/dev/null; then
    echo "Errors found..."
    grep -i error /tmp/regression-output.txt
else
    echo "All tests pass!"
fi
