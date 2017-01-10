<?php

declare(strict_types=0);


class Elama_PHP7_Sniffs_Declarations_StrictTypesDeclarationSniff implements PHP_CodeSniffer_Sniff
{

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

        foreach ($tokens as $key => $token) {
            if ($token['code'] !== T_DECLARE) {
                continue;
            }

            $declaration = '';
            $i = 0;
            while ($tokens[$key + $i]['content'] !== ';') {
                if ($tokens[$key + $i]['code'] === T_WHITESPACE) {
                    $i++;
                    continue;
                }
                $declaration = $declaration . $tokens[$key + $i]['content'];
                $i++;
            }

            if ($declaration === 'declare(strict_types=1)'){
                return;
            }
        }

        $error = "Each php tag has to have 'strict_types=1' declaration";
        $phpcsFile->addError($error, $stackPtr);
    }

}
