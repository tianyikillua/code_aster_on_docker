if [ -z "$ASRUN" ]; then
    ASRUN=/home/aster/aster/bin/as_run
fi

TEST_DIR=/home/aster/shared/test

mkdir -p $TEST_DIR
cd $TEST_DIR
$ASRUN --list --all --output=$TEST_DIR/testcases
# $ASRUN --list --all --filter='"parallel" in testlist' --output=$TEST_DIR/testcases

for testcase in `cat $TEST_DIR/testcases`
do
    echo "Working on $testcase..."
    $ASRUN --test $testcase $TEST_DIR >> $TEST_DIR/screen
done

$ASRUN --diag --only_nook --astest_dir=$TEST_DIR > $TEST_DIR/diag
