<?php

class Elama_PHP_Sniffs_Formatting_MaxNewlinesInRowSniff implements PHP_CodeSniffer_Sniff
{

    public $maxNewlinesInRow = 2;

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

    public function process(PHP_CodeSniffer_File $phpcsFile, $stackPtr)
    {
        $tokens = $phpcsFile->getTokens();
        $newlinesCount = 0;

        for ($i = 0; $i < count($tokens); $i++) {
            if ($tokens[$i]['code'] !== T_WHITESPACE) {
                if (($newlinesCount = $newlinesCount - 2) > $this->maxNewlinesInRow) {
                    $phpcsFile->addError(
                        "Found $newlinesCount newlines in a row, max {$this->maxNewlinesInRow}",
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
