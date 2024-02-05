namespace GameServers.Scheduler
{
  public enum VmStates
  {
    Unknown,
    StartRequested,
    Starting,
    Running,
    Stopping,
    Stopped,
    Deallocating,
    Deallocated,
  }
}