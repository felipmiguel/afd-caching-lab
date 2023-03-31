package com.cachepoc.app1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@EnableDiscoveryClient
@SpringBootApplication
public class CachePocApplication {

	public static void main(String[] args) {
		SpringApplication.run(CachePocApplication.class, args);
	}

}
