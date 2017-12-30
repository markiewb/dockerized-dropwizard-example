package com.example.helloworld;

import com.codahale.metrics.JmxReporter;
import com.example.helloworld.health.TemplateHealthCheck;
import com.example.helloworld.resources.HelloWorldResource;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

/**
 * <ul>
 * <li>Start via <code>java -jar ./target/dropwizard.gettingstarted-1.0-SNAPSHOT.jar server hello-world.yml</code></li>
 * <li>Open <a href="http://localhost:8080/hello-world?name=Benno">http://localhost:8080/hello-world?name=Benno</a></li>
 * <p>
 * </ul>
 */
public class HelloWorldApplication extends Application<HelloWorldConfiguration>
{
    public static void main(String[] args) throws Exception
    {
        new HelloWorldApplication().run(args);
    }

    @Override
    public String getName()
    {
        return "hello-world";
    }

    @Override
    public void initialize(Bootstrap<HelloWorldConfiguration> bootstrap)
    {
        // nothing to do yet
//        bootstrap.
    }

    @Override
    public void run(HelloWorldConfiguration configuration,
                    Environment environment)
    {
        // nothing to do yet
        HelloWorldResource resource = new HelloWorldResource(configuration.getTemplate(), configuration.getDefaultName(), environment.metrics());
        environment.jersey().register(resource);
        environment.healthChecks().register("myTemplateHealthCheck", new TemplateHealthCheck(configuration.getTemplate()));
        final JmxReporter reporter = JmxReporter.forRegistry(environment.metrics()).build();
        reporter.start();

    }

}