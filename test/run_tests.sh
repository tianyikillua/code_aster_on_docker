ASRUN=/home/aster/aster/bin/as_run
TEST_DIR=/home/aster/test

mkdir $TEST_DIR
for testcase in `$ASRUN --list --all`
do
    $ASRUN --silent --test $testcase $TEST_DIR >> dump
done
$ASRUN --diag --only_nook --astest_dir=$TEST_DIR
