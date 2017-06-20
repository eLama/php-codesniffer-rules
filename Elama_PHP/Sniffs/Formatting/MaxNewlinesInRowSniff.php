<?php

use PHP_CodeSniffer\Sniffs\Sniff;
use PHP_CodeSniffer\Files\File;

class Elama_PHP_Sniffs_Formatting_MaxNewlinesInRowSniff implements Sniff
{

    public $maxEmptyLinesInRow = 1;

    /**
     * Returns an array of tokens this test wants to listen for.
     *
     * @return array
     */
    public function register()
    {
        return array(
            T_OPEN_TAG
        );
    }

    public function process(File $phpcsFile, $stackPtr)
    {
        $tokens = $phpcsFile->getTokens();
        $newlinesCount = 0;

        for ($i = 0; $i < count($tokens); $i++) {
            if ($tokens[$i]['code'] !== T_WHITESPACE) {
                if (($emptyLinesCount = $newlinesCount - 2) > $this->maxEmptyLinesInRow) {
                    $phpcsFile->addError(
                        "Found $emptyLinesCount empty lines in a row, max {$this->maxEmptyLinesInRow}",
                        $i
                    );
                }
                $newlinesCount = 0;
                continue;
            }

            $newlinesCount++;
        }
    }

}
