package main
{
    import flash.events.Event;

    public class UserHttpManagerEvents extends Event
    {
         public static const SUCCESS_GET_PEERS:String = 'successGetPeers';
         public static const USERS_HTTP_ERROR:String = 'usersHttpError';

         public var customEventData:Object;

         public function UserHttpManagerEvents(type:String, EventData:Object):void
         {
              super(type);
              customEventData = EventData;
         }
    }
}