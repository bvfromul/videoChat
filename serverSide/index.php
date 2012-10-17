<?php
class ServerSideOfVideoChat
{
    private function writeInFile($file, $content)
    {
        if (is_writeable($file)) 
        {
            $fh = fopen($file, 'a+'); 
            fwrite($fh, $content."\n");
            fclose($fh);
            return 'true';
        }
        else
        {
            return 'false';
        }
    }

    private function returnResult($result)
    {
        header('Content-type: text/plain');
        echo '<?xml version="1.0" encoding="utf-8"?>'."\n".
              '<result>'."\n".
                  '<status>'.$result.'</status>'."\n".
              '</result>';
    }

    public function ServerSideOfVideoChat()
    {
        $file = 'pears';

        if (isset($_GET['identity']) && isset($_GET['username']))
        {
            $this->returnResult($this->writeInFile($file, $_GET['identity'].' '.$_GET['username']));
        }
        else
        {
            $this->returnResult('false');
        }
    }
}

$serverSideOfVideoChat = new ServerSideOfVideoChat();
?>