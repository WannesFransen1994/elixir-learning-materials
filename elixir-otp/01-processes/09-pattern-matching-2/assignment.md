# Assignment

## Task

Update your `counter` so that it becomes the equivalent of the class below:

```csharp
class Counter
{
    private int current;

    public Counter()
    {
        this.current = 0;
    }

    public void Inc()
    {
        ++this.current;
    }

    public void Dec()
    {
        --this.current;
    }

    public int Get()
    {
        return this.current;
    }

    public void Reset()
    {
        this.current = 0;
    }
}
```

Keep the messages as simple as possible: don't send extraneous data.
Note that only `Get` needs to send an answer back to the calling process.
