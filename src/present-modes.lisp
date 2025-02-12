;; Copyright 2019, 2020 Andrew Kenneth Wolven
;; 
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;; 
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(in-package :vk)

(defun get-present-modes (gpu surface)
  (with-foreign-object (p-count :uint32)
    (check-vk-result (vkGetPhysicalDeviceSurfacePresentModesKHR (h gpu) (h surface) p-count +nullptr+))
    (let ((count (mem-aref p-count :uint32)))
      (with-foreign-object (p-present-modes 'VkPresentModeKHR count)
	      (check-vk-result (vkGetPhysicalDeviceSurfacePresentModesKHR (h gpu) (h surface) p-count p-present-modes))
	      (loop for i from 0 below (mem-aref p-count :uint32)
	            collect (mem-aref p-present-modes 'VkPresentModeKHR i))))))

(defun get-physical-device-surface-present-mode (gpu surface)
  (let ((present-modes (get-present-modes gpu surface)))
    (if (member VK_PRESENT_MODE_MAILBOX_KHR present-modes)
        #+PRESENT-MODE-MAILBOX VK_PRESENT_MODE_MAILBOX_KHR
        #-PRESENT-MODE-MAILBOX VK_PRESENT_MODE_FIFO_KHR
        VK_PRESENT_MODE_FIFO_KHR)))
