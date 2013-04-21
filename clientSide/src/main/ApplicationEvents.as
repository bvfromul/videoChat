package main
{
    import flash.events.Event;

    public class ApplicationEvents extends Event
    {
        public static const NICK_AND_HOST_READY:String = 'nickAndHostReady';
        public static const OUTCOMING_MESSAGE:String = 'outcomingMessage';
        public static const SUCCESS_GET_PEERS:String = 'successGetPeers';
        public static const USERS_HTTP_ERROR:String = 'usersHttpError';
        public static const PEERID_READY:String = 'peeridReady';
        public static const INCOMING_MESSAGE:String = 'incomingMessage';
        public static const NO_ACTIVE_STREAM:String = 'noActiveStream';
        public static const SUCCESS_CONNECTED:String = 'successConnected';

        public var customEventData:Object;

        public function ApplicationEvents(type:String, EventData:Object = null):void
        {
            super(type);
            customEventData = EventData;
        }
    }
}