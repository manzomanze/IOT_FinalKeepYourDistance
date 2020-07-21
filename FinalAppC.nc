#include "Final.h"

configuration FinalAppC {}

implementation {
  
  components MainC, FinalC as App;
  components new TimerMilliC() as timer;
  components ActiveMessageC;
  components new AMSenderC(AM_MY_MSG);
  components new AMReceiverC(AM_MY_MSG);
  components PrintfC;
  components SerialStartC;
    
  //Boot interface
  App.Boot -> MainC.Boot;
  //Timer interface
  App.MilliTimer -> timer;
  //Send and Receive interfaces
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  //Radio Control
  App.SplitControl -> ActiveMessageC;
  //Interfaces to access package fields
  App.Packet -> AMSenderC;
  
}
