using Xunit;

namespace BusinessTest_NetCore3
{
    public class UnitTest
    {
        [Fact]
        public void Test_NetCore2()
        {
            new Business_Standard2.SomeClass_Standard2().SomeMethod(2, 1);
        }
    }
}
