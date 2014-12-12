/*******************************************************************************
 * File         : arraystack.c
 * Author(s)    : Tekin Ozbek <tekin@tekinozbek.com>
 ******************************************************************************/

#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include <arraystack.h>

void ods_arraystack_init(arraystack_t* s, size_t elem_size) {

    assert((void *)s > NULL);
    assert(elem_size > 0);

    s->array = malloc(elem_size);

    assert(s->array > NULL);

    s->length       = 0;
    s->alloc_length = 1;
    s->elem_size    = elem_size;
}

static void ods_arraystack_resize(arraystack_t* s) {

    size_t realloc_size = 1;
    
    if (s->length > 0)
        realloc_size = s->length * 2;

    s->array = realloc(s->array, realloc_size * s->elem_size);

    assert(s->array > NULL);

    s->alloc_length = realloc_size;
}

void ods_arraystack_reserve(arraystack_t* s, size_t n) {

    assert((void *)s > NULL);
    assert(n >= s->length);

    if (n == s->length)
        return;

    s->array = realloc(s->array, n * s->elem_size);

    assert(s->array > NULL);

    s->alloc_length = n;
}

void ods_arraystack_reverse(arraystack_t* s) {

    size_t i, j;
    void* tmp;

    assert((void *)s > NULL);

    tmp = malloc(s->elem_size);
    
    assert(tmp > NULL);

    if (s->length < 2)
        return;

    for (i = 0, j = s->length - 1; i < j; ++i, --j) {

        memcpy(tmp, (char *)s->array + (i * s->elem_size), s->elem_size);
        
        memcpy(
            (char *)s->array + (i * s->elem_size),
            (char *)s->array + (j * s->elem_size),
            s->elem_size
        );

        memcpy((char *)s->array + (j * s->elem_size), tmp, s->elem_size);
    }
}

void ods_arraystack_add(arraystack_t* s, size_t pos, void* elem) {

    assert((void *)s > NULL);
    assert(elem > NULL);
    assert(pos <= s->length);

    if (1 + s->length > s->alloc_length)
        ods_arraystack_resize(s);

    /* shift elements to the right according to insertion position */
    memmove((char *)s->array + ((1 + pos) * s->elem_size),
            (char *)s->array + (pos * s->elem_size),
            (s->length - pos) * s->elem_size);

    /* add the element in */
    memcpy((char *)s->array + (pos * s->elem_size), elem, s->elem_size);

    ++s->length;
}

void ods_arraystack_get(arraystack_t* s, size_t pos, void* elem) {

    assert((void *)s > NULL);
    assert(elem > NULL);
    assert(s->length > 0);
    assert(pos < s->length);

    memcpy(elem, (char *)s->array + (pos * s->elem_size), s->elem_size);
}

void ods_arraystack_set(arraystack_t* s, size_t pos,
                        void* elem, void* old_elem) {

    assert((void *)s > NULL);
    assert(elem > NULL);
    assert(s->length > 0);
    assert(pos < s->length);

    /* first copy the old data*/
    if (old_elem > NULL)
        memcpy(old_elem, (char *)s->array + (pos * s->elem_size), s->elem_size);

    memcpy((char *)s->array + (pos * s->elem_size), elem, s->elem_size);
}

void ods_arraystack_remove(arraystack_t* s, size_t pos, void* elem_out) {

    assert((void *)s > NULL);
    assert(s->length > 0);
    assert(pos < s->length);

    /* copy the removed data */
    if (elem_out > NULL)
        memcpy(elem_out, (char *)s->array + (pos * s->elem_size), s->elem_size);

    /* shift the elements to the left */
    memmove((char *)s->array + (pos * s->elem_size),
            (char *)s->array + ((1 + pos) * s->elem_size),
            (s->length - pos - 1) * s->elem_size);

    --s->length;

    /* resize if necessary */
    if (s->length * 3 < s->alloc_length)
        ods_arraystack_resize(s);
}

void ods_arraystack_clear(arraystack_t* s) {

    assert((void *)s > NULL);

    s->length       = 0;
    s->alloc_length = 1;
    s->array        = realloc(s->array, s->elem_size);

    assert(s->array > NULL);
}

void ods_arraystack_copy(arraystack_t* dest, size_t dest_pos,
                         arraystack_t* src, size_t src_pos,
                         size_t num_elems) {

    size_t elem_size;

    if (num_elems < 1)
        return;

    assert((void *)dest > NULL);
    assert((void *)src  > NULL);
    assert(dest->elem_size == src->elem_size); /* elem size mismatch */
    assert(dest_pos <= dest->length);
    assert(src_pos + num_elems <= src->length);

    elem_size = dest->elem_size;

    if (dest->length + num_elems > dest->alloc_length)
        ods_arraystack_reserve(dest, dest->length + num_elems);

    memmove(
        (char *)dest->array + ((dest_pos + num_elems) * elem_size),
        (char *)dest->array + (dest_pos * elem_size),
        (dest->length - dest_pos) * elem_size
    );

    memcpy(
        (char *)dest->array + (dest_pos * elem_size),
        (char *)src->array  + (src_pos  * elem_size),
        num_elems * elem_size
    );

    dest->length += num_elems;
}

void ods_arraystack_dispose(arraystack_t* s) {

    assert((void *)s > NULL);
    
    free(s->array);
}
