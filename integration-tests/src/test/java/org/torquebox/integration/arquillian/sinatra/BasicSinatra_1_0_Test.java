package org.torquebox.integration.arquillian.sinatra;

import static org.junit.Assert.*;

import org.jboss.arquillian.api.Deployment;
import org.jboss.arquillian.api.Run;
import org.jboss.arquillian.api.RunModeType;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.Test;
import org.openqa.selenium.WebElement;
import org.torquebox.integration.arquillian.AbstractIntegrationTestCase;

@Run(RunModeType.AS_CLIENT)
public class BasicSinatra_1_0_Test extends AbstractIntegrationTestCase {

    @Deployment
    public static JavaArchive createDeployment() {
        return createDeployment( "sinatra/basic-sinatra-knob.yml" );
    }

    @Test
    public void testPostAlot() throws Exception {
        int numIterations = 500;
        for (int i = 0; i < numIterations; ++i) {
            if (i % 10 == 0) {
                System.err.print( "." );
            }
            try {
                postCycle();
            } catch (Exception e) {
                System.err.println( "\n\nFailed at iteration " + i + ": " + e.getMessage() + "\n" );
                throw e;
            }
        }
        System.err.println( "\nCompleted " + numIterations );
    }

    protected void postCycle() {
        driver.get( "http://localhost:8080/basic-sinatra/poster" );
        WebElement submit = driver.findElementById( "submit" );
        submit.click();
        WebElement success = driver.findElementById( "success" );
        assertNotNull( success );
        assertEquals( "you posted nothing", success.getText() );
    }

}