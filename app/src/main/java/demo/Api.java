package demo;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api")
public class Api {

  private final RestTemplate rt = new RestTemplate();
  private final String downstream = System.getenv().getOrDefault(
      "DOWNSTREAM_URL", "https://httpbin.org/delay/1");

  @GetMapping("/health")
  public String health() { return "OK"; }

  @GetMapping("/checkout")
  public String checkout() {
    try { Thread.sleep(150); } catch (InterruptedException ignored) {}
    String echo = rt.getForObject(downstream, String.class);
    return "checkout ok | downstream=" + (echo != null ? "200" : "null");
  }
}
