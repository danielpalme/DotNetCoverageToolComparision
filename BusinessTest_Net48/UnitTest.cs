using Xunit;

namespace BusinessTest_Net48
{
    public class UnitTest
    {
        [Fact]
        public void Test_Net48()
        {
            new Business_Standard2.SomeClass_Standard2().SomeMethod(2, 1);
            new Business_Net48.SomeClass_Net48().SomeMethod(2, 1);
        }
    }
}
