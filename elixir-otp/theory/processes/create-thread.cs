void ThreadProc()
{
    Console.WriteLine("Runs on separate thread");
}

var thread = new Thread(ThreadProc);
thread.Start();