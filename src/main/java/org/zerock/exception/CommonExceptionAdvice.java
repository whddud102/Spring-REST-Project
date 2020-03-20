package org.zerock.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
@ResponseStatus(HttpStatus.NOT_FOUND)
public class CommonExceptionAdvice {
	
	@ExceptionHandler(NoHandlerFoundException.class)
	public String handle404(NoHandlerFoundException ex) {
		return "custom404";
	}
}
