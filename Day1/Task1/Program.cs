using System;
using System.IO;

namespace Task1
{
    internal class Program
    {
        internal static void Main(string[] args)
        {
            var lines = File.ReadAllLines(Path.Combine(Environment.CurrentDirectory, @"..\..\..\input.txt"));
            var count = -1;
            var last = 0;
            foreach (var line in lines)
            {
                var parsed = int.Parse(line);
                if (parsed > last)
                {
                    count++;
                }
                last = parsed;
            }
            Console.WriteLine(count);
        }
    }
}
