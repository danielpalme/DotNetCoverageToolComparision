using Xunit;

namespace BusinessTest_Net47
{
    public class UnitTest
    {
        [Fact]
        public void Test_Net47()
        {
            new Business_Standard2.SomeClass_Standard2().SomeMethod(2, 1);
            new Business_Net47.SomeClass_Net47().SomeMethod(2, 1);
        }
    }
}
