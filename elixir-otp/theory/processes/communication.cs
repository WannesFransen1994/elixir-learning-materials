// Child simulator
bool arrived;

new Thread( () => {
  while ( !arrived ) {
    Console.WriteLine("Are we there yet?")
  }
  Console.WriteLine("Finally!");
} ).Start();

DriveToDisneyLand();
arrived = true;
