<?php
class ServerSideOfVideoChat
{
    private function writeInFile($file, $content)
    {
        if(!file_exists($file))
        {
            $fh = fopen($file, "w");
            fwrite($fh, $content."\n");
            fclose($fh);
        }
        elseif (is_writeable($file))
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
                  '<update>'.$result.'</update>'."\n".
              '</result>';
    }

    public function ServerSideOfVideoChat()
    {
        $file = 'peers';

        if (isset($_GET['identity']) && isset($_GET['username']))
        {
            $this->returnResult($this->writeInFile($file, $_GET['identity'].' '.$_GET['username'].' '.date("m.d.y").' '.date("H:i:s")));
        }
        else
        {
            $this->returnResult('false');
        }
    }
}

$serverSideOfVideoChat = new ServerSideOfVideoChat();
?>