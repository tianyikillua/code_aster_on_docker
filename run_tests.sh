mkdir /home/aster/test
for testcase in `as_run --list --all`
do
    as_run --test $testcase /home/aster/test
done
as_run --diag --only_nook --astest_dir=/home/aster/test
