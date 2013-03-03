<?php
class ServerSideOfVideoChat
{
    private function writeInFile($file, $content)
    {
        if (is_writeable($file) || !file_exists($file))
        {
            $fh = fopen($file, 'a+'); 
            fwrite($fh, "\n".$content);
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

    private function returnPeers($peers)
    {
        header('Content-type: text/plain');
        for ($count = 0; $count < count($peers); $count++)
        {
            echo '<peer>'."\n".
                    '<id>'.$peers[$count]['peer'].'</id>'."\n".
                    '<nick>'.$peers[$count]['nick'].'</nick>'."\n".
                 '</peer>';
        }
    }

    private function readPeers($file)
    {
        $content = file_get_contents($file);

        $count = 0; $i = 0;
        do {
            $i = strpos($content, "\n", $i);
            if ($i!==false) {
                $array_of_peers[$count]['peer'] = substr($content, $i+1, 64);
                $array_of_peers[$count]['nick'] = substr($content, $i+66, strpos($content, ' ', $i+66)-$i-66);
                $array_of_peers[$count]['day']  = substr($content, $i+66 + strlen($array_of_peers[$count]['nick']) + 1, 8);
                $array_of_peers[$count]['time'] = substr($content, $i+66 + strlen($array_of_peers[$count]['nick']) + 10, 8);
                $count++;
            }
            $i++;
        } while ($i!==false);

        return $array_of_peers;
    }

    private function deleteOldPeers($array_of_peers)
    {
        $currentTime =strtotime(date('Y-m-d H:i:s') . "-10 minutes");

        for ($count = 0; $count < count($array_of_peers); $count++)
        {
            $datePeer = strtotime($array_of_peers[$count]['day'].' '.$array_of_peers[$count]['time']);
            if ($datePeer < $currentTime || $array_of_peers[$count]['peer'] == 0)
            {
                unset($array_of_peers[$count]);
            }
        }

        return array_values($array_of_peers);
    }

    private function getPeers($file)
    {
        $array_of_peers = $this->deleteOldPeers($this->readPeers($file));

        if(count($array_of_peers) > 0)
        {
            $this->returnPeers($array_of_peers);
        }
        else
        {
            $this->returnResult('false');
        }
    }

    public function ServerSideOfVideoChat()
    {
        $file = 'peers';

        if (isset($_GET['identity']) && isset($_GET['username']))
        {
            $this->returnResult($this->writeInFile($file, $_GET['identity'].' '.$_GET['username'].' '.date("m-d-y").' '.date("H:i:s")));
        }
        elseif (isset($_GET['get_peers']))
        {
            $this->getPeers($file);
        }
        else
        {
            $this->returnResult('false');
        }
    }
}

$serverSideOfVideoChat = new ServerSideOfVideoChat();
?>