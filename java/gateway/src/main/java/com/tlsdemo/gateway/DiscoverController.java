package com.tlsdemo.gateway;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class DiscoverController {

    @Autowired
    DiscoveryClient discoveryClient;

    @GetMapping("/discover")
	public String discover() {
        String result = "";
        List<String> services = discoveryClient.getServices();
        for (String service : services) {
            result = result + String.format("%s\n", service);
            List<ServiceInstance> instances = discoveryClient.getInstances(service);
            for (ServiceInstance instance : instances) {
                result = result + String.format("  %s:%s:%s:%s:%s:%s\n", service, instance.getHost(), instance.getPort(), instance.getUri(), instance.getScheme(), instance.isSecure());
            }
		}
        return result;
	}
    
}