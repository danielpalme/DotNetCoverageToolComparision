using System;

namespace Business_Standard2
{
    public class SomeClass_Standard2
    {
        public void SomeMethod(int a, int b)
        {
            if (a > b)
            {
                Console.WriteLine("a is bigger");
            }
            else
            {
                Console.WriteLine("b is bigger");
            }
        }

        public void UncoveredMethod()
        {
            Console.WriteLine("Never executed");
        }
    }
}
