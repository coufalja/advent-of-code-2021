using System;
using System.Collections.Generic;
using System.IO;

namespace Task2
{
    internal class Program
    {
        internal static void Main(string[] args)
        {
            var lines = File.ReadAllLines(Path.Combine(Environment.CurrentDirectory, @"..\..\..\input.txt"));
            var windows = new List<int>();
            for (var i = 0; i < lines.Length; i++)
            {
                if (i >= lines.Length - 2)
                {
                    break;
                }
                windows.Add(0);
                for (var j = 0; j < 3; j++)
                {
                    var parsed = int.Parse(lines[i+j]);
                    windows[i] += parsed;
                }
            }

            var count = -1;
            var last = 0;
            foreach (var line in windows)
            {
                if (line > last)
                {
                    count++;
                }
                last = line;
            }
            Console.WriteLine(count);
        }
    }
}
