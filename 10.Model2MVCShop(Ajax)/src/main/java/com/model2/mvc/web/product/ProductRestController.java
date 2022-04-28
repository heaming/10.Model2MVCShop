package com.model2.mvc.web.product;

import java.io.File;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;


@RestController
@RequestMapping("/product/*")
public class ProductRestController {

	// field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;


	// ctor
	public ProductRestController() {
		System.out.println(this.getClass());
	}


	// method
	@RequestMapping( value="json/getProduct/{prodNo}", method=RequestMethod.GET )
	public Product getProduct(@PathVariable int prodNo) throws Exception {

		System.out.println("/json/getProduct : GET");

		return productService.getProduct(prodNo);

	}


	@RequestMapping( value="json/updateProduct/{prodNo}", method=RequestMethod.GET )
	public Product updateProduct(@PathVariable int prodNo) throws Exception {

		System.out.println("/json/updateProduct : GET");

		Product product = productService.getProduct(prodNo);

		return product;
	}


	@RequestMapping( value="json/updateProduct/{prodNo}", method=RequestMethod.POST)
	public Product updateProduct(@RequestBody Product product, MultipartFile file) throws Exception {

		System.out.println("/json/updateProduct : POST");

		// file
		if (file != null) {

			System.out.println(file);

			String fileName = file.getOriginalFilename();

			// String id = UUID.randomUUID().toString() + "_";

			String uploadPath = "C:\\Users\\bitcamp\\git\\07Model2MVCShop\\07.Model2MVCShop(URI,pattern)\\src\\main\\webapp\\images\\uploadFiles";
			File target = new File(uploadPath, fileName);

			if(!new File(uploadPath).exists()) {
				new File(uploadPath).mkdir();
			}

			file.transferTo(target);

			product.setFileName(fileName);						
		}

		productService.updateProduct(product);
		
		return productService.getProduct(product.getProdNo());
	}

	
	@RequestMapping( value="json/addProduct", method=RequestMethod.POST)
	public Product addProduct(@RequestBody Product product) throws Exception {
		
		System.out.println("/json/addProduct : POST");
		
		productService.addProduct(product);
		
		return product;
		
	}
	
	
	@RequestMapping( value="json/listProduct") 
	public Map<String, Object> listProduct(@RequestBody Search search) throws Exception {
		
		System.out.println("/json/listProduct : GET");
		
		return productService.getProductList(search);
		
	}
	
}
