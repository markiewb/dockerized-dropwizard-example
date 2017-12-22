package com.example.helloworld.resources;

import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.Timer;
import com.codahale.metrics.annotation.Timed;
import com.example.helloworld.api.Saying;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;

@Path("/hello-world")
@Produces(MediaType.APPLICATION_JSON)
public class HelloWorldResource
{
    private final String template;
    private final String defaultName;
    private final AtomicLong counter;
    private MetricRegistry metrics;

    public HelloWorldResource(String template, String defaultName, MetricRegistry metrics)
    {
        this.template = template;
        this.defaultName = defaultName;
        this.metrics = metrics;
        this.counter = new AtomicLong();
    }

    @GET
    @Timed
    public Saying sayHello(@QueryParam("name") Optional<String> name)
    {
        metrics.counter("myCounter").inc();
        Timer.Context context = metrics.timer("myTimer").time();
        String value = null;
        try
        {
            value = String.format(template, name.orElse(defaultName));
            Thread.sleep((long) (Math.random() * 2000));
        } catch (InterruptedException e)
        {
            e.printStackTrace();
        } finally
        {
            context.stop();
        }
        return new Saying(counter.incrementAndGet(), value);
    }
}