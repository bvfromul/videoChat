<?php
class ServerSideOfVideoChat
{
    private function processData($file, $id, $nick, $day, $time)
    {
        switch ($this->checkUserData($file, $id, $nick))
        {
            case 'update':
                return $this->updateDate($file, $id, $nick, $day, $time);
            break;

            case 'error':
                return 'busy nickname';
            break;

            case 'new':
                return $this->writeInFile($file, $id.' '.$nick.' '.$day.' '.$time);
            break;
        }
    }

    private function updateDate($file, $id, $nick, $day, $time)
    {
        $recordedContent = file_get_contents($file);

        $oldDate = substr($recordedContent, strpos($recordedContent, $id.' '.$nick) + strlen($id.' '.$nick) + 1, 17);
        $recordedContent = str_replace($id.' '.$nick.' '.$oldDate, $id.' '.$nick.' '.$day.' '.$time, $recordedContent);

        if (is_writeable($file) || !file_exists($file))
        {
            $fh = fopen($file, 'w');
            fwrite($fh, $recordedContent);
            fclose($fh);
            return 'true';
        }
        else
        {
            return 'false';
        }
    }

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

    private function checkUserData($file, $id, $nick)
    {
        $recordedContent = file_get_contents($file);

        if (strpos($recordedContent, $nick) !== false)
        {
            if (strpos($recordedContent, $id.' '.$nick) !== false)
            {
                return 'update';
            }
            else
            {
                return 'error';
            }
        }
        else
        {
            return 'new';
        }
    }

    private function saveTopicalPeers($file, $peers)
    {
        if (is_writeable($file) || !file_exists($file))
        {
            $fh = fopen($file, 'w');

            for ($count = 0; $count < count($peers); $count++)
            {
                fwrite($fh, "\n".$peers[$count]['peer'].' '.$peers[$count]['nick'].' '.$peers[$count]['day'] .' '.$peers[$count]['time']);
            }

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
        echo '<?xml version="1.0" encoding="utf-8"?>'."\n".'<peers>'."\n";
        for ($count = 0; $count < count($peers); $count++)
        {
            echo '<peer>'."\n".
                    '<id>'.$peers[$count]['peer'].'</id>'."\n".
                    '<nick>'.$peers[$count]['nick'].'</nick>'."\n".
                 '</peer>'."\n";
        }
        echo '</peers>';
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
        $currentTime = strtotime(date('Y-m-d H:i:s') . "-2 minutes");
        $countArrayItems = count($array_of_peers);

        for ($count = 0; $count < $countArrayItems; $count++)
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
        $topicalPeers = $this->deleteOldPeers($this->readPeers($file));

        if(count($topicalPeers) > 0)
        {
            $this->returnPeers($topicalPeers);
            $this->saveTopicalPeers($file, $topicalPeers);
        }
        else
        {
            $this->returnResult('false');
        }
    }

    public function ServerSideOfVideoChat()
    {
        $file = 'peers';
        date_default_timezone_set('Europe/Moscow');

        if (isset($_GET['identity']) && isset($_GET['username']))
        {
            $this->returnResult($this->processData($file, $_GET['identity'], $_GET['username'], date("y-m-d"), date("H:i:s")));
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